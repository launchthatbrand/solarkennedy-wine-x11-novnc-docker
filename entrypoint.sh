#!/usr/bin/env bash

is_enabled () {
    echo "$1" | grep -q -i -E "^(yes|on|true|1)$"
}

is_disabled () {
    echo "$1" | grep -q -i -E "^(no|off|false|0)$"
}

# Set ENV
USER_PASSWD=${USER_PASSWD:-"$(openssl passwd -1 -salt "$(openssl rand -base64 6)" "${USER_NAME}")"}

# Run noVNC
if is_enabled "${USE_NOVNC}"; then
    wget -O - https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar -xzv -C /root/ && mv /root/noVNC-1.1.0 /root/novnc && ln -s /root/novnc/vnc_lite.html /root/novnc/index.html
    wget -O - https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar -xzv -C /root/ && mv /root/websockify-0.9.0 /root/novnc/utils/websockify
fi

# Create the VNC password
echo "home is ${HOME}"
mkdir -p "${HOME}"/.vnc
x11vnc -storepasswd "${USER_PASSWD}" "${HOME}"/.vnc/passwd

# Start Supervisord
/usr/bin/supervisord