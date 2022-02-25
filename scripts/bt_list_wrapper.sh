#!/bin/bash

bt_list=$(timeout 5.0 bt list)

if [ $? != 0 ]; then
	# TODO: to avoid this we need to keepalive the mediator from the extension side
	tmux display "[CRITICAL ERROR] bt crashed! restart your browser! tmux-browser cant save your sessions!"
	exit 1
fi

echo "$bt_list"
