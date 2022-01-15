#!/bin/bash

# TODO: get it from option
SESSIONS_DIR=$HOME/.tmux/browser-sessions
browser_new_window="firefox --new-window"

current_session=$(tmux display-message -p '#S')
# Using localhost to don't query any web browser
tab_id_name=localhost:1212/dont_close-tmux-browser_$current_session

focus_tabid_window()
{
	window_id=$(bt list | cut -f1,3 | grep "$tab_id_name$" | cut -f2 -d ".")
	active_window_title=$(bt query +active -windowId $window_id | cut -f2)
	wmctlr_window_id=$(wmctrl -l | grep -F "$active_window_title" | cut -f1 -d " ")
	wmctrl -i -R $wmctlr_window_id
}

if bt list | grep -q "$tab_id_name$"; then
	tmux display "[INFO] Session is already running, jumping to active window!"
	focus_tabid_window
	exit
fi

# TODO: firefox dependent
if ! ps -ax | grep firefox | grep -q -v grep; then
	tmux display "[INFO] Boot firefox first to avoid stucking tmux"
	exit
fi

# TODO: pin the tab
eval $browser_new_window $tab_id_name
sleep 0.5 # TODO: while check to avoid sleep
window_id=$(bt list | cut -f1,3 | grep "$tab_id_name$" | cut -f 1-2 -d ".")

if [[ $(echo $window_id | tr -cd ' \t' | wc -c) != '0' ]]; then
	tmux display "[ERROR] Multiple windows with the same tab id name: $tab_id_name"
	exit
fi

if [ -f $SESSIONS_DIR/$current_session ]; then
	tmux display "Restoring from $SESSIONS_DIR/$current_session"
	bt open $window_id < $SESSIONS_DIR/$current_session
else
	tmux display "New Browser Opened"
fi

focus_tabid_window
