#!/bin/bash
SLEEP=10
DISPLAYOPTS="--file-transfer=off --open-files=off --daemon=no --speaker=disabled --microphone=disabled --window-close=ignore --dbus-proxy=no --dbus-control=no --desktop-scaling=off --encoding=jpeg --video-scaling=off"
SCROPTS="--bit-rate 1M --max-size 500 --fullscreen"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

device_is_connected=false

for word in $(</tmp/device_list.txt)
do
	# echo $id
  	if [[ "$1" = "$word" ]]
  	then 
  		device_is_connected=true
  	fi
done

if $device_is_connected ; then
	export DISPLAY=":$3"
	adb -s $1 shell media volume --show --stream 3 --set 0
	xpra start --bind-tcp=0.0.0.0:$2 --html=on --start="scrcpy --serial $1 $SCROPTS" $DISPLAYOPTS --daemon=no $DISPLAY &
	sleep $SLEEP
fi
