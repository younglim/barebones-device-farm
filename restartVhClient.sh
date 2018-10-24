#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

sudo pkill vhclientx86_64
sleep 5

sudo $DIR/vhclientx86_64 -c $DIR/.vhui -n
sleep 15

adb devices -l
