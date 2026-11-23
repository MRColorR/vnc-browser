"""Docker integration checks: python tests/test_container.py IMAGE chromium|firefox."""

import json
from pathlib import Path
import subprocess
import sys
import tempfile
import time
import unittest
import urllib.request
import uuid


IMAGE, BROWSER = sys.argv[1:3]
del sys.argv[1:3]


def docker(*args):
    result = subprocess.run(
        ["docker", *args], capture_output=True, text=True, encoding="utf-8", timeout=90
    )
    if result.returncode:
        raise RuntimeError(f"docker {args[0]} failed: {result.stderr}")
    return result.stdout.strip()


class ContainerTests(unittest.TestCase):
    def setUp(self):
        self.names = []
        self.volumes = []
        self.files = tempfile.TemporaryDirectory()
        self.addCleanup(self.files.cleanup)
        self.addCleanup(self.cleanup_docker)

    def cleanup_docker(self):
        for name in self.names:
            docker("rm", "-f", name)
        for volume in self.volumes:
            docker("volume", "rm", volume)

    def create(self, *options, scripts=None, fixture=None):
        name = f"vnc-test-{uuid.uuid4().hex[:10]}"
        command = []
        if fixture:
            command = ["bash", "-c", "python3 -m http.server 8765 --bind 127.0.0.1 "
                       "--directory /tmp >/tmp/profile-server.log 2>&1 & "
                       "exec /usr/local/bin/customizable_entrypoint.sh"]
        docker(
            "create", "--name", name, "--label", "vnc-browser.integration-test=true",
            "-p", "127.0.0.1::6080", "-e", "VNC_PASSWORD=regtest",
            "-e", "STARTING_WEBSITE_URL=about:blank", *options, IMAGE, *command,
        )
        self.names.append(name)
        if scripts:
            folder = Path(self.files.name) / name
            folder.mkdir()
            for filename, content in scripts.items():
                (folder / filename).write_text(content, encoding="utf-8", newline="\n")
            docker("cp", f"{folder}/.", f"{name}:/app/custom_entrypoints_scripts")
        if fixture:
            docker("cp", str(fixture), f"{name}:/tmp/profile-test.html")
        docker("start", name)
        return name

    def eventually(self, check, timeout=45):
        deadline = time.monotonic() + timeout
        last_error = None
        while time.monotonic() < deadline:
            try:
                if check():
                    return
            except (RuntimeError, OSError) as error:
                last_error = error
            time.sleep(0.5)
        self.fail(f"Condition did not become true: {last_error}")

    def logs(self, name):
        # Docker emits both application stdout and stderr through this command.
        started_at = docker("inspect", "--format", "{{.State.StartedAt}}", name)
        result = subprocess.run(
            ["docker", "logs", "--since", started_at, name],
            capture_output=True, text=True, encoding="utf-8", timeout=10,
        )
        return result.stdout + result.stderr

    def ready(self, name):
        def check():
            logs = self.logs(name)
            self.assertNotIn("regtest", logs)
            self.assertNotIn("FATAL", logs)
            self.assertNotIn("SIGSEGV", logs)
            port = docker("port", name, "6080/tcp").rsplit(":", 1)[1]
            with urllib.request.urlopen(f"http://127.0.0.1:{port}/vnc.html", timeout=2) as response:
                return (
                    response.status == 200
                    and f"success: {BROWSER} entered RUNNING state" in logs
                    and "success: Xvnc entered RUNNING state" in logs
                )
        self.eventually(check)

    def stop_cleanly(self, name):
        docker("stop", "--time", "20", name)
        state = json.loads(docker("inspect", "--format", "{{json .State}}", name))
        self.assertFalse(state["OOMKilled"])
        self.assertIn(state["ExitCode"], (0, 143))
        self.assertIn("stopped: " + BROWSER, self.logs(name))

    def test_default_start_restart_and_password(self):
        name = self.create()
        self.ready(name)
        security_check = (
            "import socket; s=socket.create_connection(('127.0.0.1',5900),timeout=3); "
            "assert s.recv(12).startswith(b'RFB'); s.sendall(b'RFB 003.008\\n'); "
            "count=s.recv(1)[0]; assert s.recv(count)==bytes([2])"
        )
        docker("exec", name, "python3", "-c", security_check)
        self.assertEqual("600", docker("exec", name, "stat", "-c", "%a", "/root/.vnc/passwd"))
        self.stop_cleanly(name)
        docker("start", name)
        self.ready(name)
        self.stop_cleanly(name)

    def test_custom_scripts_finish_in_filename_order(self):
        name = self.create("-e", "CUSTOMIZE=true", scripts={
            "10-first.py": "#!/usr/bin/env python3\nprint('hook-first')\n",
            "20-last.sh": "#!/bin/bash\necho hook-last\n",
        })
        self.eventually(lambda: "Customization completed." in self.logs(name))
        self.ready(name)
        logs = self.logs(name)
        self.assertLess(logs.index("hook-first"), logs.index("hook-last"))
        self.stop_cleanly(name)

    def test_empty_custom_directory_keeps_running(self):
        name = self.create("-e", "CUSTOMIZE=true")
        self.eventually(lambda: "Customization completed." in self.logs(name))
        self.ready(name)
        self.stop_cleanly(name)

    def test_failed_custom_script_stops_services(self):
        name = self.create("-e", "CUSTOMIZE=true", scripts={"fail.sh": "exit 23\n"})
        self.assertEqual("23", docker("wait", name))
        self.assertIn("stopped: " + BROWSER, self.logs(name))

    def test_missing_custom_directory_fails(self):
        name = self.create("-e", "CUSTOMIZE=true", "-e", "CUSTOM_ENTRYPOINTS_DIR=/missing")
        self.assertEqual("1", docker("wait", name))
        self.assertIn("Custom entrypoints directory not found", self.logs(name))

    def test_profile_survives_container_recreation(self):
        volume = f"vnc-test-{uuid.uuid4().hex}"
        docker("volume", "create", volume)
        self.volumes.append(volume)
        profile = "/root/.config/chromium" if BROWSER == "chromium" else "/root/.config/mozilla"
        options = ("--hostname", "vnc-profile-test", "-v", f"{volume}:{profile}",
                   "-e", "STARTING_WEBSITE_URL=http://127.0.0.1:8765/profile-test.html")
        fixture = Path(self.files.name) / "profile-test.html"
        fixture.write_text(
            """<!doctype html><title>Profile test</title><script>
const open = indexedDB.open("vnc-test", 1);
open.onupgradeneeded = () => open.result.createObjectStore("state");
open.onsuccess = () => {
  const tx = open.result.transaction("state", "readwrite", {durability: "strict"});
  const store = tx.objectStore("state");
  const read = store.get("visit");
  read.onsuccess = () => store.put("restored-visit", "visit");
  tx.oncomplete = () => fetch("/result?value=" + (read.result || "first-visit"));
};
</script>""", encoding="utf-8"
        )
        for title in ("first-visit", "restored-visit"):
            name = self.create(*options, fixture=fixture)
            self.ready(name)
            def reported():
                server_log = docker("exec", name, "cat", "/tmp/profile-server.log")
                if "/result?value=" not in server_log:
                    return False
                self.assertIn(f"/result?value={title}", server_log)
                return True

            self.eventually(reported)
            self.stop_cleanly(name)

    def test_dark_mode_is_opt_in(self):
        fixture = Path(self.files.name) / "profile-test.html"
        fixture.write_text(
            '<!doctype html><title>Theme test</title><script>'
            'const dark = matchMedia("(prefers-color-scheme: dark)").matches;'
            'fetch("/theme?value=" + (dark ? "dark" : "light"));</script>',
            encoding="utf-8",
        )
        for options, theme in (((), "light"), (("-e", "THEME=dark"), "dark")):
            with self.subTest(theme=theme):
                name = self.create(
                    "-e", "STARTING_WEBSITE_URL=http://127.0.0.1:8765/profile-test.html",
                    *options, fixture=fixture,
                )
                self.ready(name)
                self.eventually(lambda: "/theme?value=" in docker(
                    "exec", name, "cat", "/tmp/profile-server.log"))
                server_log = docker("exec", name, "cat", "/tmp/profile-server.log")
                self.assertIn(f"/theme?value={theme}", server_log)
                def desktop_running():
                    logs = self.logs(name)
                    return all(f"success: {service} entered RUNNING state" in logs
                               for service in ("fluxbox", "xterm"))

                self.eventually(desktop_running)
                if theme == "dark":
                    settings = docker("exec", name, "cat", "/run/vnc-browser-theme/fluxbox.init",
                                      "/run/vnc-browser-theme/BlueNight")
                    self.assertRegex(settings, r"session\.styleFile:\s+/run/vnc-browser-theme/BlueNight")
                    self.assertIn("background.color: #333333", settings)
                self.stop_cleanly(name)

    def test_invalid_theme_stops_startup(self):
        for value in ("blue", ""):
            with self.subTest(value=value):
                name = self.create("-e", f"THEME={value}", "-e", "CUSTOMIZE=true")
                self.assertEqual("2", docker("wait", name))
                logs = self.logs(name)
                self.assertIn("Expected light or dark", logs)
                self.assertNotIn("Customization is enabled", logs)

    def test_stop_during_custom_script(self):
        name = self.create("-e", "CUSTOMIZE=true", scripts={
            "long.sh": "#!/bin/bash\ntrap 'exit 0' TERM\necho hook-started\nsleep 60\n",
        })
        self.eventually(lambda: "hook-started" in self.logs(name))
        self.ready(name)
        self.stop_cleanly(name)

    def test_stop_during_startup_delay(self):
        name = self.create("-e", "CUSTOMIZE=true")
        self.ready(name)
        self.assertNotIn("Customization completed.", self.logs(name))
        self.stop_cleanly(name)


if __name__ == "__main__":
    unittest.main(verbosity=2)
