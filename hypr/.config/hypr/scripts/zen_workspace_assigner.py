#!/usr/bin/env python3

import json
import subprocess
import time


TITLE_TO_WORKSPACE = {
    "Akiflow": 1,
    "Messenger | Facebook": 3,
    "Gmail": 10,
}

ZEN_CLASS = "zen"
CHECK_INTERVAL_SECONDS = 2


def get_clients():
    result = subprocess.run(
        ["hyprctl", "clients", "-j"],
        capture_output=True,
        text=True,
        check=True,
    )
    return json.loads(result.stdout)


def move_to_workspace(address, workspace):
    subprocess.run(
        ["hyprctl", "dispatch", "movetoworkspacesilent", f"{workspace},address:{address}"],
        check=False,
    )


def main():
    while True:
        try:
            clients = get_clients()
        except Exception:
            time.sleep(CHECK_INTERVAL_SECONDS)
            continue

        for client in clients:
            if client.get("class", "").lower() != ZEN_CLASS:
                continue

            title = client.get("title", "")
            workspace = client.get("workspace", {}).get("id")
            address = client.get("address")

            for needle, target_workspace in TITLE_TO_WORKSPACE.items():
                if needle.lower() in title.lower() and workspace != target_workspace:
                    move_to_workspace(address, target_workspace)
                    break

        time.sleep(CHECK_INTERVAL_SECONDS)


if __name__ == "__main__":
    main()
