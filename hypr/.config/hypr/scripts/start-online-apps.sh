#!/bin/bash

timeout_seconds=60
check_interval=2
elapsed=0

while [ "$elapsed" -lt "$timeout_seconds" ]; do
    if ping -c 1 -W 1 1.1.1.1 >/dev/null 2>&1; then
        /opt/zen-browser-bin/zen-bin "https://www.youtube.com/" &
        slack &
        omarchy-launch-webapp "https://web.akiflow.com/#/planner/today" &
        omarchy-launch-webapp "https://www.facebook.com/messages/e2ee/t" &
        omarchy-launch-webapp "https://discord.com/channels/@me" &
        omarchy-launch-webapp "https://mail.google.com/" &
        wait
        exit 0
    fi

    sleep "$check_interval"
    elapsed=$((elapsed + check_interval))
done

exit 0
