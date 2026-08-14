#!/bin/bash

set +e

noctalia &

/usr/lib/polkit-kde-authentication-agent-1 >/dev/null 2>&1 &

# portal
/usr/lib/xdg-desktop-portal-wlr  >/dev/null 2>&1 &

# keep clipboard content
wl-clip-persist --clipboard regular --reconnect-tries 0 >/dev/null 2>&1 &

# clipboard content manager
wl-paste --type text --watch cliphist store >/dev/null 2>&1 &

# alt tab for mango
wswitch --daemon >/dev/null 2>&1 &
