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

vhclientx86_64 -t LIST

DEVICESCOUNT=$(expr $(adb devices | tee >(wc -l) | tail -1) - 2)

sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

while [ $DEVICESCOUNT -le 0 ]
do

	VHCLIENTERROR="$(vhclientx86_64 -t LIST | awk /'No response from IPC server'/)"
	while [ ! -z $VHCLIENTERROR ]
        do
        	echo "Error with VirtualHere Client... restarting"
        	$DIR/restartVhClient.sh
        	VHCLIENTERROR="$(vhclientx86_64 -t LIST | awk /'No response from IPC server'/)"
		sleep $SLEEP
	done

	echo "Retry - Number of devices connected: $DEVICESCOUNT"
	adb kill-server
	sleep $SLEEP
	adb start-server
	DEVICESCOUNT=$(expr $(adb devices | tee >(wc -l) | tail -1) - 2)

done

echo "Number of devices connected: $DEVICESCOUNT"

echo "Prepare device_info.txt"
$DIR/prepare_device_info_list.sh

echo "Start Live View Sessions"
$DIR/update_connection.sh

