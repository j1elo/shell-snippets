#!/usr/bin/env bash
set -eu -o pipefail  # Abort on errors, disallow undefined variables

# Restore permissions for all files in a directory.
#
# This is needed in order to preserve ownership and access permissions while
# using `rsync` or some Version Control Systems to transfer files.
#
# For example, it is likely that the 'root' ownership will be lost if you
# commit such file into Git or SVN. With the scripts 'perms_create' and
# 'perms_restore', you would be able to properly restore all files.
#
# Changes:
# 2017-10-03 Juan Navarro <juan.navarro@gmx.es>
# - Initial version.

# Settings
permissionsFile="$PWD/JKOW_perms"

# Check root permissions
[ "$(id -u)" -eq 0 ] || { echo "Please run as root"; exit 1; }

# Check file permissions list
[ -f "$permissionsFile" ] || { echo "File permissions list not found: $permissionsFile"; exit 1; }

# Restore default permissions for all the directory hierarchy.
setfacl --restore="$permissionsFile"

echo "File permissions & ownership have been restored"

# ------------

echo ""
echo "[$0] Done."
