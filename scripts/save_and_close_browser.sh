#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
current_session=$1
tab_id_name=localhost:1212/dont_close-tmux-browser_$current_session

bt_list=$($CURRENT_DIR/bt_list_wrapper.sh) || exit $?
if echo "$bt_list" | grep -q "$tab_id_name$"; then
	window_id=$(echo "$bt_list" | cut -f1,3 | grep "$tab_id_name$" | cut -f1,2 -d ".")

	$CURRENT_DIR/save_session.sh $current_session $window_id "$(echo "$bt_list")"

	tab_ids=$(echo "$bt_list" | grep "$window_id\\." | cut -f1)

	echo $tab_ids | bt close
fi
