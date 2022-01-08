#!/bin/bash

# TODO: get it from option
SESSIONS_DIR=$HOME/.tmux/browser-sessions
browser_new_window="firefox --new-window"

current_session=$(tmux display-message -p '#S')
# Using localhost to don't query any web browser
tab_id_name=localhost:1212/dont_close-tmux-browser_$current_session

if bt list | grep -q $tab_id_name; then
	# TODO: jump to the session window
	tmux display "[ERROR] Session is already running!"
	exit
fi

# TODO: firefox dependent
if ! ps -ax | grep firefox | grep -q -v grep; then
	tmux display "[INFO] Boot firefox first to avoid stucking tmux"
	exit
fi

# TODO: pin the tab
# TODO: open in focus
eval $browser_new_window $tab_id_name
sleep 0.5 # TODO: while check to avoid sleep
window_id=$(bt list | cut -f1,3 | grep $tab_id_name | cut -f 1-2 -d ".")

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
