#!/usr/bin/env bash

tmux_option()
{
	local option="$1"
	local default_value="$2"
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

sessions_dir()
{
	echo "$(tmux_option "@browser_session_dir" "$HOME/.tmux/browser-sessions")"
}
