#!/bin/bash
adb kill-server
sudo pkill -9 adb
sudo pkill -9 vhclientx86_64
wait $(pgrep adb)
wait $(pgrep vhclientx86_64)
