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

log_error() {
	local error_msg="$1"
	local error_description="$2"

	local LOG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../logs"
	mkdir -p "$LOG_DIR"
	local timestamp
	timestamp=$(date +'%c')

	local indented_description
	indented_description=$(echo "$error_description" | sed 's/^/\t/')

	{
		echo "[$timestamp] $error_msg"
		echo -e "$indented_description"
		echo ""
	} >>"$LOG_DIR/error_log.txt"

	tmux display "$error_msg"
}
