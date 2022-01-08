#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# TODO: option
tmux bind-key B run-shell "$CURRENT_DIR/scripts/open_browser.sh"

# TODO: option
tmux set -g @resurrect-hook-post-save-all "$CURRENT_DIR/scripts/save_sessions.sh"

# TODO: hook detaches?
