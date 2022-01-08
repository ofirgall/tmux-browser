#!/usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

hello_world="$CURRENT_DIR/scripts/hello_world.sh"

main()
{
	echo $($hello_world)
}

main
