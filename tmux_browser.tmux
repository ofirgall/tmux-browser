#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/helpers.sh"

tmux bind-key "$(tmux_option "@open_browser_key" "B")" run-shell "screen -dm -- $CURRENT_DIR/scripts/open_browser.sh"

if [ "$(tmux_option "@browser_dont_hook_to_resurrect" "0")" == "0" ]; then
	tmux set -g @resurrect-hook-post-save-all "$CURRENT_DIR/scripts/save_sessions.sh"
fi
