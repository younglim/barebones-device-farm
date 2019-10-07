DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
sudo pkill -9 vhclientx86_64
sudo pkill -9 vhuit64
sleep 5

if [[ $(which dpkg-query) ]]; then
    echo "Ubuntu"

    dpkg-query -l linux-modules-extra-$(uname -r)
    package_installed_error=$?

    if [ $package_installed_error -eq 1 ]; then
    	sudo apt-get install -y linux-modules-extra-$(uname -r)
    fi
else
    echo "RedHat"
fi


sudo modprobe vhci-hcd
sudo iptables -A INPUT -p tcp --dport 8083 -j ACCEPT
sudo xpra start --bind-tcp=0.0.0.0:8083 --html=on --start="vhuit64 -c $DIR/.vhui" --daemon=no :200
