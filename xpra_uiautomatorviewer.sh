#!/bin/sh

if [[ $(which dpkg-query) ]]; then
    echo "Ubuntu"

    dpkg-query -l wmctrl
    package_installed_error=$?

    if [ $package_installed_error -eq 1 ]; then
    	sudo apt-get install -y wmctrl
    fi
else
    echo "RedHat"
fi

export PATH=/opt/android-sdk/tools/bin:$PATH
DISPLAY=":201"

xpra start --bind-tcp=0.0.0.0:13000 --html=on --start-child="uiautomatorviewer $DISPLAY" --dpi=96 --speaker=disabled --microphone=disabled --window-close=disconnect --dbus-proxy=no --dbus-control=no --encoding=rgb --compressors=lz4 --daemon=no --speaker=off $DISPLAY &

# uiautomatorviewer &
UIAUTOMATORVIEWER_PID=$!

trap "kill $UIAUTOMATORVIEWER_PID" SIGINT SIGTERM

UIAUTOMATORVIEWER_WINDOW=""

while [ -z "$UIAUTOMATORVIEWER_WINDOW" ] ; do
  UIAUTOMATORVIEWER_WINDOW=$( wmctrl -l | grep "UI Automator" | awk '{print $1;}')
  sleep 0.1
done

echo "Found UIAutomatorViewer Window $UIAUTOMATORVIEWER_WINDOW"

wmctrl -i -r $UIAUTOMATORVIEWER_WINDOW -b toggle,maximized_vert,maximized_horz
