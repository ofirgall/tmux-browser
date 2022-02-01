#!/usr/bin/env bash
while true
do
	wmctlr_window_id=$(wmctrl -l | grep -F "$1" | cut -f1 -d " ")
	if [ ! -z "$wmctlr_window_id" ]; then
		echo $wmctlr_window_id
		break
	fi
	sleep 0.05
done
