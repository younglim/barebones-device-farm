DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
sudo pkill vhclientx86_64
sleep 5
sudo $DIR/vhuit64 -c $DIR/.vhui
