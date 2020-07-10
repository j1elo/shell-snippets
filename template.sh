#!/usr/bin/env bash

#/ Template shell script with safer settings than the defaults in a Bash shell,
#/ and some other useful functions.
#/
#/ Usage
#/ =====
#/
#/ template.sh [-h|--help]
#/
#/
#/ Options
#/ =======
#/
#/ -h|--help : Print this help message.

# Bash options for strict error checking
set -o errexit -o errtrace -o pipefail -o nounset

# Self path
SELF_FILE="$(basename "${BASH_SOURCE[0]}")" # File name

# Log function
# This disables and re-enables debug trace mode, only if it was already set
# Source: https://superuser.com/a/1338887/922762
readonly LOG_FILE="/tmp/${SELF_FILE}.log"
shopt -s expand_aliases # This trick requires enabling aliases in Bash
echo_and_restore() {
    echo "[$SELF_FILE] $(cat -)" | tee --append "$LOG_FILE" >&2
    # shellcheck disable=SC2154
    case "$flags" in (*x*) set -x; esac
}
alias log='({ flags="$-"; set +x; } 2>/dev/null; echo_and_restore) <<<'

# A specific action to be done only in case of error
# Note that due to "errexit", both on_error and on_exit are called. Keep this
# in mind because anything you do in on_error will change the return code "$?".
# on_error() {
#     error "Some error has happened!"
#     exit 1 # Not really needed if "errexit" is set
# }
# trap on_error ERR

# Exit trap -- Runs at the end or, thanks to "errexit", upon any error
on_exit() {
    # * Remove temporary files.
    # * Stop or restart services.
    # * Etc.
    { _RC="$?"; set +x; } 2>/dev/null
    if ((_RC)); then echo "ERROR ($_RC)"; else echo "SUCCESS"; fi
}
trap on_exit EXIT

# Help message (extracted from script headers)
usage() { grep '^#/' "$0" | cut --characters=4-; exit 0; }
REGEX='(^|\W)(-h|--help)($|\W)'
if [[ "$*" =~ $REGEX ]]; then usage; fi

# Trace all commands
set -o xtrace



# Script start
# ============

log "Script running"
