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
	echo "Retry - Number of devices connected: $DEVICESCOUNT"
	adb kill-server
	sleep $SLEEP
	adb start-server
	DEVICESCOUNT=$(expr $(adb devices | tee >(wc -l) | tail -1) - 2)
done

echo "Number of devices connected: $DEVICESCOUNT"

echo "Start Live View Sessions"
# Mi 3
xpra start --bind-tcp=0.0.0.0:14500 --html=on --start="scrcpy -s MYSERIALNUMBER -m 768" $DISPLAYOPTS --daemon=no :100 &
sleep $SLEEP

# Mi A1
xpra start --bind-tcp=0.0.0.0:14501 --html=on --start="scrcpy -s MYSERIALNUMBER2 -m 768" $DISPLAYOPTS --daemon=no :101 &
sleep $SLEEP


