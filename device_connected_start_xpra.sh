#!/bin/bash
SLEEP=10
DISPLAYOPTS="--dpi=96 --speaker=disabled --microphone=disabled --window-close=disconnect --dbus-proxy=no --dbus-control=no --desktop-scaling=off --encoding=h264 --video-scaling=0.1"
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
	xpra start --bind-tcp=0.0.0.0:$2 --html=on --start="scrcpy -s $1 $SCROPTS" $DISPLAYOPTS --daemon=no :$3
fi
