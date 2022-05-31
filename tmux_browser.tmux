#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/helpers.sh"

tmux bind-key "$(tmux_option "@open_browser_key" "B")" run-shell -b "$CURRENT_DIR/scripts/open_browser.sh"

if [ "$(tmux_option "@browser_dont_hook_to_resurrect" "0")" == "0" ]; then
	tmux set -g @resurrect-hook-post-save-all "$CURRENT_DIR/scripts/save_sessions.sh"
fi

if [ "$(tmux_option "@browser_launch_on_attach" "0")" == "1" ]; then
	tmux set-hook -g 'client-attached[8921]' "run-shell "$CURRENT_DIR/scripts/open_browser.sh""
else
	tmux set-hook -gu 'client-attached[8921]' "run-shell "$CURRENT_DIR/scripts/open_browser.sh""
fi

if [ "$(tmux_option "@browser_close_on_deattach" "1")" == "1" ]; then
	cmd="$CURRENT_DIR/scripts/save_and_close_browser.sh \$(tmux display-message -p \#S)"
	tmux set-hook -g 'client-detached[8921]' "run-shell '$cmd'"
else
	tmux set-hook -gu 'client-detached[8921]' "run-shell "$CURRENT_DIR/scripts/save_and_close_browser.sh""
fi
