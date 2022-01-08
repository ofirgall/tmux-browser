#!/usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# TODO: option
tmux bind-key B run-shell "$CURRENT_DIR/scripts/open_browser.sh"

# TODO: option
set -g @resurrect-hook-post-save-all '$CURRENT_DIR/scripts/save_sessions.sh'
