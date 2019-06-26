#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

DEVICES=`adb devices | tail  -n +2 | cut -f1`

XPRA_PORT=14500
XPRA_DISPLAY=100

OUTPUT_FILE=$DIR/device_info.txt

[ -f $OUTPUT_FILE ] && rm $OUTPUT_FILE

touch $OUTPUT_FILE

for DEVICE in $DEVICES
do
  CMD_MANUFACTURER="$(adb -s $DEVICE shell getprop ro.product.manufacturer)"
  CMD_MODEL="$(adb -s $DEVICE shell getprop ro.product.model) $(adb -s $DEVICE shell getprop ro.build.version.release)"
  CMD_PRODUCTNAME="$(adb -s $DEVICE shell getprop ro.semc.product.name)"

  MANUFACTURER=${CMD_MANUFACTURER//[^a-zA-Z0-9_-]/}
  MODEL=${CMD_MODEL//[^ \.a-zA-Z0-9_-]/}
  MODEL=${MODEL// /_}
  PRODUCTNAME=${CMD_PRODUCTNAME//[^a-zA-Z0-9_-]/}

  [ ! -z "$PRODUCTNAME" ] && MODEL=$PRODUCTNAME

  printf "$MANUFACTURER|$MODEL|$DEVICE|$XPRA_PORT|$XPRA_DISPLAY|false\n" >> $OUTPUT_FILE

  let "XPRA_PORT=XPRA_PORT+1"
  let "XPRA_DISPLAY=XPRA_DISPLAY+1"

done

cat $OUTPUT_FILE
