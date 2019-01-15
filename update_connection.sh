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

		if $is_connected && ! $6;
		then 
			msg+=" is now connected."
			# awk '{/false/,"true",$6}' table.txt
			# awk '{print $0, "true"}' table.txt > table2.txt
			sed -i.bak "${line_count}s/false/true/" /tmp/table.txt
			rm /tmp/table.txt.bak
			echo $msg
			$DIR/device_connected_start_xpra.sh $3 $4 $5
		elif ! $is_connected && $6;
		then
			msg+=" is now disconnected."
			xpra stop :$5
			sed -i.bak "${line_count}s/true/false/" /tmp/table.txt
			rm /tmp/table.txt.bak
			echo $msg
			# awk '{print $0, "false"}' table.txt > table2.txt
		fi

	done < /tmp/table.txt
	
	SCRCPY_COUNT="$(sudo systemctl status device-farm | grep ' scrcpy' | wc -l)"

        echo "bef SCRCPY_COUNT: $SCRCPY_COUNT"
        echo "bef SCRCPY_COUNT_LAST: $SCRCPY_COUNT_LAST"

        if [ "$SCRCPY_COUNT" -ge "$SCRCPY_COUNT_LAST" ];
        then
                echo "greater equal"
                SCRCPY_COUNT_LAST=$SCRCPY_COUNT
		echo "aft SCRCPY_COUNT_LAST: $SCRCPY_COUNT_LAST"
		echo "aft SCRCPY_COUNT: $SCRCPY_COUNT"
        elif [ "$SCRCPY_COUNT" -lt "$SCRCPY_COUNT_LAST" ];
        then
                echo "less than"
		echo "SCRCPY_COUNT_LAST: $SCRCPY_COUNT_LAST"
                echo "SCRCPY_COUNT: $SCRCPY_COUNT"
                echo "Restarting Device Farm as some scrcpy session is dead"
                sudo pkill -9 scrcpy
                wait $(pgrep scrcpy)
                sudo pkill -9 adb
		wait $(pgrep adb)
                sudo systemctl restart device-farm
        fi

        sleep 30
	
done
