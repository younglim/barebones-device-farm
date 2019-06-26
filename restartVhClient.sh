#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
echo "$DIR"

sudo pkill -9 vhclientx86_64
wait $(pgrep vhclientx86_64)

sudo vhclientx86_64 -c $DIR/.vhui -l $DIR/vhserver.log &
echo "VirtualHere is running at $
