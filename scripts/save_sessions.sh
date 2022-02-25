#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

bt_list=$($CURRENT_DIR/bt_list_wrapper.sh) || exit $?

while read session; do
	window_id=$(echo $session | cut -f 1-2 -d ".")
	session_name=$(echo $session | grep -Po "(?<=dont_close-tmux-browser_).+$")
	# echo "Window ID:$window_id"
	# echo "Session Name:$session_name"

	$CURRENT_DIR/save_session.sh $session_name $window_id "$(echo "$bt_list")"
done < <(echo "$bt_list" | cut -f1,3 | grep dont_close-tmux-browser)
