#!/usr/bin/env bash
# Checked with ShellCheck (https://www.shellcheck.net/)

#/ Check if this script is being run with root privileges.

# Shell setup.
source "bash.conf.sh" || { echo "Cannot load Bash config file"; exit 1; }

# Trace all commands (to stderr).
set -o xtrace

# Check root permissions
[[ "$(id -u)" -eq 0 ]] || {
    echo "ERROR: Please run as root user (or with 'sudo')"
    exit 1
}

echo "Script running successfully with root privileges!"
