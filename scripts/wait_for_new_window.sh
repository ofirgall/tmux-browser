#!/usr/bin/env bash
while true
do
	window_id=$(bt list | cut -f1,3 | grep "$1$" | cut -f 1-2 -d ".")
	if [ ! -z "$window_id" ]; then
		echo $window_id
		break
	fi
	tmux display "[INFO] Waiting for window to be open"
	sleep 0.2
done
