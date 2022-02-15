#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

SESSIONS_DIR=$(sessions_dir)
mkdir -p $SESSIONS_DIR

session_name=$1
window_id=$2
bt_list=$3

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
