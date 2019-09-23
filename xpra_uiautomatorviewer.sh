#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
xpra stop :201
xpra start --bind-tcp=0.0.0.0:13000 --html=on --start-child="$DIR/uiautomatorviewer_maximize.sh" --dpi=96 --speaker=disabled --microphone=disabled --window-close=disconnect --dbus-proxy=no --dbus-control=no --encoding=rgb --compressors=lz4 --daemon=no --speaker=off :201 &
