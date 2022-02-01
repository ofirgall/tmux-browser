#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# TODO: get it from option
SESSIONS_DIR=$HOME/.tmux/browser-sessions
browser_new_window="screen -dm -- firefox --new-window"

current_session=$(tmux display-message -p '#S')
# Using localhost to don't query any web browser
tab_id_name=localhost:1212/dont_close-tmux-browser_$current_session

# TODO: option, if no wmctrl present
focus_tabid_window()
{
	window_id=$1
	active_window_title=$(bt query +active -windowId $window_id | cut -f2)
	# TODO: option the timeout
	wmctlr_window_id=$(timeout 5.0 "$CURRENT_DIR/wait_for_active_window.sh" $active_window_title)
	if [ -z "$wmctlr_window_id" ]; then
		tmux display "[ERROR] Active window not found, not jumping."
		exit 0
	fi
	wmctrl -i -R $wmctlr_window_id
}

tmux display "[INFO] tmux-browser: Opening Browser!"
bt_list=$(bt list)
if echo "$bt_list" | grep -q "$tab_id_name$"; then
	tmux display "[INFO] Session is already running, jumping to active window!"
	window_id=$(echo "$bt_list" | cut -f1,3 | grep "$tab_id_name$" | cut -f2 -d ".")
	focus_tabid_window $window_id
	exit 0
fi

# TODO: pin the tab
eval $browser_new_window $tab_id_name
# TODO: option the timeout
window_id=$(timeout 5.0 "$CURRENT_DIR/wait_for_new_window.sh" $tab_id_name)

if [ -z "$window_id" ]; then
	tmux display "[ERROR] Web browser window didnt found"
	exit 0
fi

if [[ $(echo $window_id | tr -cd ' \t' | wc -c) != '0' ]]; then
	tmux display "[ERROR] Multiple windows with the same tab id name: $tab_id_name"
	exit 0
fi

if [ -f $SESSIONS_DIR/$current_session ]; then
	tmux display "Restoring from $SESSIONS_DIR/$current_session"
	bt open $window_id < $SESSIONS_DIR/$current_session
else
	tmux display "New Browser Opened"
fi

window_id=$(echo $window_id | cut -f2 -d ".")
focus_tabid_window $window_id
exit 0
