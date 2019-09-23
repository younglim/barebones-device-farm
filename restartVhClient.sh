#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
echo "$DIR"

vhclientx86_64=$(which vhclientx86_64)

sudo pkill -9 vhclientx86_64
wait $(pgrep vhclientx86_64)

sudo modprobe vhci-hcd
sudo $vhclientx86_64 -c $DIR/.vhui -l $DIR/vhserver.log &
echo "VirtualHere is running at $"
