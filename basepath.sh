#!/usr/bin/env bash
set -eu -o pipefail  # Abort on errors, disallow undefined variables

# Get path information from the running script's file path.
#
# This script will extract all components of its own path and print each one
# separately.
#
# Sources:
# - http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
# - https://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script
#
# Changes:
# 2017-10-03 Juan Navarro <juan.navarro@gmx.es>
# - Initial version.

# Path information
BASEPATH="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"  # Absolute canonical path
BASENAME="$(basename "$0")"  # Complete file name
FILENAME="${BASENAME%.*}"    # File name without extension
FILEEXTN="${BASENAME##*.}"   # File extension without name

echo "BASEPATH: $BASEPATH"
echo "BASENAME: $BASENAME"
echo "FILENAME: $FILENAME"
echo "FILEEXTN: $FILEEXTN"

# ------------

echo ""
echo "[$0] Done."
