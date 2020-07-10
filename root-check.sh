#!/usr/bin/env bash

# Snippet: Check if this script is being run with root privileges.

# Bash options for strict error checking
set -o errexit -o errtrace -o pipefail -o nounset

# Self path
SELF_FILE="$(basename "${BASH_SOURCE[0]}")" # File name

# Check root permissions
[[ "$(id -u)" -eq 0 ]] || {
    echo "ERROR: Please run as root user (or with 'sudo')"
    exit 1
}

echo "Script running with root privileges: [$SELF_FILE]"
