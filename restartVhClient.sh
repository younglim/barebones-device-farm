#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
echo "$DIR"

vhclientx86_64=$(which vhclientx86_64)

sudo pkill -9 vhclientx86_64
wait $(pgrep vhclientx86_64)

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
sudo $vhclientx86_64 -c $DIR/.vhui -l $DIR/vhserver.log &
echo "VirtualHere is running at $"
