#!/usr/bin/env bash

# Snippet: Catch errors and print a message before exiting.

# Bash options for strict error checking
set -o errexit -o errtrace -o pipefail -o nounset

# Trace all commands
set -o xtrace

# Exit trap -- Runs at the end or, thanks to "errexit", upon any error
on_exit() {
    { _RC="$?"; set +x; } 2>/dev/null
    if ((_RC)); then echo "ERROR ($_RC)"; else echo "SUCCESS"; fi
}
trap on_exit EXIT

function func_that_fails {
    # This call should fail due to lack of read permissions for "/root/"
    ls /root/
}

func_that_fails
