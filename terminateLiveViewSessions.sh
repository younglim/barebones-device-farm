#!/bin/bash

sudo killall -w scrcpy

adb kill-server
sudo killall -w adb

sudo killall -w vhclientx86_64
