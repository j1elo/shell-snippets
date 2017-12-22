#!/usr/bin/env bash
set -eu -o pipefail  # Abort on errors, disallow undefined variables

# Create an output pipe for debug logs.
#
# This scripts uses the tool `mkfifo` to create an output pipe which can be
# used by an application to generate a debug log.
#
# Sources:
# - http://stackoverflow.com/questions/1221833/bash-pipe-output-and-capture-exit-status
# - http://mywiki.wooledge.org/BashFAQ/085
# - https://unix.stackexchange.com/questions/25372/turn-off-buffering-in-pipe
#
# Changes:
# 2017-10-03 Juan Navarro <juan.navarro@gmx.es>
# - Initial version.
#
# TODO:
# - Current implementation of FIFO pipe has buffering problems, and stdout
#   gets out in random order (see where the last `echo` appears).

# Path information
BASENAME="$(basename "$0")"  # Complete file name
FILENAME="${BASENAME%.*}"    # File name without extension

# Start output pipe
mkfifo log
stdbuf -oL tail -f log | tee -a "${FILENAME}.log" &
trap '{ rm log; }' EXIT  # Upon exit, remove output pipe

# ---- Commands here ----

echo "Begin sample command 1 ..." >log
ls -al /tmp/doesnotexist >log 2>&1 && RC=$? || RC=$?
echo "... End sample command 1" >log
if [ "$RC" -eq 2 ]; then
  echo "No files were found" >log
elif [ "$RC" -eq 0 ]; then
  echo "Some file(s) found" >log
else
  echo "ERROR ($RC)" >log
fi

# Generate temporary file
TEMPFILE="$(mktemp --quiet --tmpdir=/tmp tmp.XXX)"

echo "Begin sample command 2 ..." >log
ls -al "$TEMPFILE" >log 2>&1 && RC=$? || RC=$?
echo "... End sample command 2" >log
if [ "$RC" -eq 2 ]; then
  echo "No files were found" >log
elif [ "$RC" -eq 0 ]; then
  echo "Some file(s) found" >log
else
  echo "ERROR ($RC)" >log
fi

# Remove temporary file
rm "$TEMPFILE"

# ------------

echo ""
echo "[$0] Done."
