#!/usr/bin/env bash
# Checked with ShellCheck (https://www.shellcheck.net/)

#/ Test Header.
#/ This is a paragraph that includes documentation for this file. It will get
#/ printed when the script is passed "-h" or "--help" as arguments.

# Shell setup.
source "bash.conf.sh" || { echo "Cannot load Bash config file"; exit 1; }

# Trace all commands (to stderr).
#set -o xtrace

# echo "Call log() without arguments:"
# log

echo "Calls to log() with 1 argument:"
log "Call 1"
log "Call 2"
log "Call 3"

# echo "Call log() with 2 arguments:"
# log "One" "Two"

function func_that_fails {
    # This call should fail with exit code 2, due to lack of read permissions.
    ls /root/
}

log "Error test 1: Catch error and continue."
func_that_fails || log "Error caught while running 'func_that_fails'"

log "Error test 2: Don't catch error and exit early."
func_that_fails

echo "End -- Shouldn't reach here!"
