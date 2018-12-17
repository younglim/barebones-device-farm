#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

sudo pkill -9 vhclientx86_64
wait $(pgrep vhclientx86_64)

echo "" > $DIR/vhserver.log
sudo $DIR/vhclientx86_64 -c $DIR/.vhui -n -l $DIR/vhserver.log
