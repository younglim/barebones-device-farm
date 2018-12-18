# Stop all mobile device sessions

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

DISPLAYOPTS="--video-scaling=100 --desktop-fullscreen=true --pixel-depth=16 --desktop-scaling=auto --window-close=ignore --speaker=disabled --microphone=disabled --pulseaudio=no"

echo "Terminating any existing live view sessions"
$DIR/terminateLiveViewSessions.sh

echo "Restart VirtualHere connection to devices"
$DIR/restartVhClient.sh

echo "Print VirtualHere Server Log"
cat $DIR/vhserver.log

adb start-server
SLEEP=10

$DIR/vhclientx86_64 -t LIST

DEVICESCOUNT=$(expr $(adb devices | tee >(wc -l) | tail -1) - 2)

while [ $DEVICESCOUNT -le 0 ]
do

	VHCLIENTERROR="$($DIR/vhclientx86_64 -t LIST | awk /'No response from IPC server'/)"
	while [ ! -z $VHCLIENTERROR ]
        do
        	echo "Error with VirtualHere Client... restarting"
        	$DIR/restartVhClient.sh
        	VHCLIENTERROR="$($DIR/vhclientx86_64 -t LIST | awk /'No response from IPC server'/)"
		sleep $SLEEP
	done

	echo "Retry - Number of devices connected: $DEVICESCOUNT"
	adb kill-server
	sleep $SLEEP
	adb start-server
	DEVICESCOUNT=$(expr $(adb devices | tee >(wc -l) | tail -1) - 2)

done

echo "Number of devices connected: $DEVICESCOUNT"


echo "Start Live View Sessions"

DISPLAYOPTS="--speaker=disabled --microphone=disabled --window-close=disconnect --dbus-proxy=no --dbus-control=no --desktop-scaling=off --pixel-depth=16 --encoding=h264 --video-scaling=0.1"
SCROPTS="--bit-rate 1M --max-size 720"

# Mi 3
xpra start --bind-tcp=0.0.0.0:14500 --html=on --start="scrcpy -s MYSERIALNUMBER $SCROPTS" $DISPLAYOPTS --daemon=no :100 &
sleep $SLEEP

# Mi A1
xpra start --bind-tcp=0.0.0.0:14501 --html=on --start="scrcpy -s MYSERIALNUMBER2 $SCROPTS" $DISPLAYOPTS --daemon=no :101 &
sleep $SLEEP


