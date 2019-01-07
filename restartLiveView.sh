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
#renice 19 -p $$
adb devices -l > /tmp/device_list.txt

# Galaxy S4
$DIR/device_connected_start_xpra.sh XXXXXXXX 14500 100 

# Mi 3
$DIR/device_connected_start_xpra.sh YYYYYYYY 14501 101 
