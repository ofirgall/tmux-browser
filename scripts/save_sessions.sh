#!/bin/bash

# TODO: get it from option
SESSIONS_DIR=$HOME/.tmux/browser-sessions
mkdir -p $SESSIONS_DIR

while read session; do
	window_id=$(echo $session | cut -f 1-2 -d ".")
	session_name=$(echo $session | grep -Po "(?<=dont_close-tmux-browser_).+$")
	# echo "Window ID:$window_id"
	# echo "Session Name:$session_name"
	# echo "Tabs:"

	rm -f $SESSIONS_DIR/$session_name
	while read tab; do
		tab_url=$(echo $tab | cut -f2 -d " ")
		if echo $tab_url | grep -q "dont_close-tmux-browser_"; then
			continue
		fi

		echo $tab_url >> $SESSIONS_DIR/$session_name
	done < <(bt list | cut -f1,3 | grep "$window_id\.")
done < <(bt list | cut -f1,3 | grep dont_close-tmux-browser)

