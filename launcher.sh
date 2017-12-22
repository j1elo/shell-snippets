#!/usr/bin/env bash
set -eu -o pipefail  # Abort on errors, disallow undefined variables

# Configure the environment and launch an application.
#
# This script configures the environment as required, and then launches
# a program which has the same name as this script.
#
# Notes:
# - "$@" expands to a list of the script's arguments.
# - ${VAR:-0} expands to VAR, or to '0' if VAR is not set.
#
# Changes:
# 2017-10-03 Juan Navarro <juan.navarro@gmx.es>
# - Initial version.

# Path information
BASEPATH="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"  # Absolute canonical path
BASENAME="$(basename "$0")"  # Complete file name
FILENAME="${BASENAME%.*}"    # File name without extension

# General variables
RUNPATH="${BASEPATH}/${FILENAME}"

# Generate sample test application
if [[ ! -f "$RUNPATH" ]]; then
  tee "$RUNPATH" > /dev/null <<'EOF'
#! /usr/bin/env sh
echo "I'm the application!"
echo "Myself: $0"
echo "Argument 1: $1"
echo "Argument 2: $2"
EOF
  chmod +x "$RUNPATH"
  RUNPATH_DELETE=1
fi

# Configure some example libraries
export QTDIR="/opt/Qt-4.8.4-release"
export QT_PLUGIN_PATH="$QTDIR/plugins"
export LD_LIBRARY_PATH="$QTDIR/lib:${LD_LIBRARY_PATH:-}"

# Launch target
"$RUNPATH" "$@"

# Remove sample test application
[[ "${RUNPATH_DELETE:-0}" -eq 1 ]] && { rm "$RUNPATH"; }

# ------------

echo ""
echo "[$0] Done."
