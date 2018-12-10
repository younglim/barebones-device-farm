#!/bin/bash
xpra stop :100 :101 :102 :103 :104 :105 :106 :107 :108 :200
adb kill-server
sudo pkill -9 adb
sudo pkill -9 vhclientx86_64
