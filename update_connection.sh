#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

column -t -s "|" $DIR/device_info.txt > /tmp/table.txt

SCRCPY_COUNT_LAST=0

while true
do

	adb devices -l > /tmp/device_list.txt

	line_count=0
	while read -r line
	do
	    line_count=$((line_count+1))
	    #echo $line_count
	    set $line

	    is_connected=false

	    for word in $(</tmp/device_list.txt)
		do
			# echo $id
		  	if [[ "$3" = "$word" ]]
		  	then 
		  		is_connected=true
		  	fi
		done

		# echo $1
		# echo $is_connected

		msg="$1" 
		msg+=" " 
		msg+="$2"
		#echo $6

		# Not connected previously, connected now
		if $is_connected && ! $6;
		then 
			msg+=" is now connected."
			# awk '{/false/,"true",$6}' table.txt
			# awk '{print $0, "true"}' table.txt > table2.txt
			sed -i.bak "${line_count}s/false/true/" /tmp/table.txt
			rm /tmp/table.txt.bak
			echo $msg
			$DIR/device_connected_start_xpra.sh $3 $4 $5
		# Connected previously, not connected now
		elif ! $is_connected && $6;
		then
			msg+=" is now disconnected."
			xpra stop :$5
			sed -i.bak "${line_count}s/true/false/" /tmp/table.txt
			rm /tmp/table.txt.bak
			echo $msg
			# awk '{print $0, "false"}' table.txt > table2.txt
			echo "Kill xpra for the disconnected device"
			kill $(pgrep -a xpra | grep "$3" | awk '{print $1;}')
			kill $(pgrep -a scrcpy | grep "$3" | awk '{print $1;}')
		elif $is_connected ;
		then
			SCRCPY_IS_ALIVE=$(pgrep -a scrcpy | grep "$3" | awk '{print $1;}' | wc -l)
			
			if [ $SCRCPY_IS_ALIVE -eq 0 ] ;
			then
				echo "SCRCPY is dead for $1 $2"
				# kill $(pgrep -a xpra | grep "$3" | awk '{print $1;}')
				XPRA_PID_TO_KILL=$(pgrep -a xpra | grep "$3" | awk '{print $1;}')
				echo "XPRA_PID_TO_KILL $XPRA_PID_TO_KILL"
				kill $XPRA_PID_TO_KILL
				wait $XPRA_PID_TO_KILL
				$DIR/device_connected_start_xpra.sh $3 $4 $5
			fi
		fi
	done < /tmp/table.txt


	sleep 30
done
