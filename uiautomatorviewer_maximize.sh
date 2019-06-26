#!/bin/sh
uiautomatorviewer &
echo $!
sleep 3
export UI_DISPLAY=$(wmctrl -l | grep "UI Automator" | awk '{print $1;}')
wmctrl -i -r $UI_DISPLAY -b toggle,maximized_vert,maximized_horz
