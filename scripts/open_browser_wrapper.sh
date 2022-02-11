#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
screen -dm -- $CURRENT_DIR/open_browser.sh
