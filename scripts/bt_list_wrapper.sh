#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/helpers.sh"

TIMEOUT="$(tmux_option "@browser_brotab_timeout" "5.0")"
bt_list=$(timeout $TIMEOUT bt list)

if [ $? != 0 ]; then
  # TODO: to avoid this we need to keepalive the mediator from the extension side

  log_error \
    "[ERROR] Multiple windows with same tab id: $tab_id_name. See logs." \
    "TODO: add something more descriptive here."

  exit 1
fi

echo "$bt_list"
