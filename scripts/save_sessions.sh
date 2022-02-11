#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

SESSIONS_DIR=$(sessions_dir)
mkdir -p $SESSIONS_DIR

bt_list=$($CURRENT_DIR/bt_list_wrapper.sh) || exit $?

while read session; do
	window_id=$(echo $session | cut -f 1-2 -d ".")
	session_name=$(echo $session | grep -Po "(?<=dont_close-tmux-browser_).+$")
	# echo "Window ID:$window_id"
	# echo "Session Name:$session_name"
	# echo "Tabs:"

	tmpfile=$(mktemp /tmp/tmux-browser.XXXXXX)
	found_special_tab=0
	while read tab; do
		tab_url=$(echo $tab | cut -f2 -d " ")
		if echo $tab_url | grep -q "dont_close-tmux-browser_"; then
			found_special_tab=1
			continue
		fi

		echo $tab_url >> $tmpfile
	done < <(echo "$bt_list" | cut -f1,3 | grep "$window_id\.")

	# Dont override if the tab didnt found
	if [ $found_special_tab -eq 1 ]; then
		mv $tmpfile $SESSIONS_DIR/$session_name
	else
		rm $tmpfile
	fi
done < <(echo "$bt_list" | cut -f1,3 | grep dont_close-tmux-browser)
