#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
LOG=$DIR/liveView.log

$DIR/restartLiveView.sh &> $LOG

