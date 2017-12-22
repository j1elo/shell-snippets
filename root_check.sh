#!/usr/bin/env bash
set -eu -o pipefail  # Abort on errors, disallow undefined variables

# Check if this script is being run with root privileges.
#
# Changes:
# 2017-10-03 Juan Navarro <juan.navarro@gmx.es>
# - Initial version.

# Check root permissions
[ "$(id -u)" -eq 0 ] || { echo "Please run as root"; exit 1; }

echo "Script running with root privileges: [$0]"

# ------------

echo ""
echo "[$0] Done."
