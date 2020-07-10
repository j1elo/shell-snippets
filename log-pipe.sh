#!/usr/bin/env bash

# Create an output pipe for debug logs.
#
# This script uses `mkfifo` to create an output pipe which can be used by an
# script or application to generate a debug log.
#
# Sources:
# * http://stackoverflow.com/questions/1221833/bash-pipe-output-and-capture-exit-status
# * http://mywiki.wooledge.org/BashFAQ/085
# * https://unix.stackexchange.com/questions/25372/turn-off-buffering-in-pipe

# Bash options for strict error checking
set -o errexit -o errtrace -o pipefail -o nounset

# Self path
SELF_FILE="$(basename "${BASH_SOURCE[0]}")" # File name
SELF_NAME="${SELF_FILE%.*}"                 # File name without extension

# Make output pipe
mkfifo log
stdbuf --output=L tail -f log | tee -a "${SELF_NAME}.log" &

# Exit trap -- Runs at the end or, thanks to "errexit", upon any error
on_exit() {
    { _RC="$?"; set +x; } 2>/dev/null
    if ((_RC)); then echo "ERROR ($_RC)"; else echo "SUCCESS"; fi

    # Upon exit, remove output pipe
    [[ -p log ]] && rm log
}
trap on_exit EXIT



# Example commands
# ================

# All these commands achieve logging just by redirecting their output to the
# pipe that we previously created.

echo ">>>> Begin sample command 1" >log
ls -al /tmp/doesnotexist >log 2>&1 && RC=$? || RC=$?
echo "<<<< End sample command 1" >log
if [[ "$RC" -eq 2 ]]; then
    echo "No files were found" >log
elif [[ "$RC" -eq 0 ]]; then
    echo "Some file(s) found" >log
else
    echo "ERROR ($RC)" >log
fi

echo "Generate temporary file" >log
TEMP_FILE="$(mktemp)"

echo ">>>> Begin sample command 2" >log
ls -al "$TEMP_FILE" >log 2>&1 && RC=$? || RC=$?
echo "<<<< End sample command 2" >log
if [[ "$RC" -eq 2 ]]; then
    echo "No files were found" >log
elif [[ "$RC" -eq 0 ]]; then
    echo "Some file(s) found" >log
else
    echo "ERROR ($RC)" >log
fi

# Remove temporary file
echo "Remove temporary file" >log
rm "$TEMP_FILE"
