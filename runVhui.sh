DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
sudo pkill -9 vhclientx86_64
sudo pkill -9 vhuit64
sleep 5

sudo xpra start --bind-tcp=0.0.0.0:13000 --html=on --start="$DIR/vhuit64 -c $DIR/.vhui" --daemon=no :200

