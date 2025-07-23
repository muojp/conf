#!/bin/bash

STATUS='closed'
STATUS_POWER='0'
FILE="/opt/autoshutdown/closed_count"
THRESHOLD=30

IS_CLOSED=$(grep $STATUS /proc/acpi/button/lid/LID0/state)
IS_POWER_DISCONNECTED=$(grep $STATUS_POWER /sys/class/power_supply/ADP1/online)

function reset() {
	echo -n 0 > $FILE
}

if [ "$IS_CLOSED" != '' ] && [ "$IS_POWER_DISCONNECTED" != '' ]; then
	NUM=$(cat $FILE)
	((NUM=NUM+1))
	if [[ $NUM -ge $THRESHOLD ]]; then
		reset
		sync ; sync
		sudo poweroff
	else
		echo -n $NUM > $FILE
	fi
else
		reset
fi
