#!/usr/bin/env bash
# Checked with ShellCheck (https://www.shellcheck.net/)

#/ Ask the user for confirmation before doing something.

# Shell setup.
source "bash.conf.sh" || { echo "Cannot load Bash config file"; exit 1; }

# Trace all commands (to stderr).
#set -o xtrace



# "Are you sure?"
# ===============

function do_something {
    echo "Function do_something has been called and will do something"
}

function check_confirmation {
    echo "You are about to do something"
    local REPLY; read -r -p "Are you sure? [y/N] " -n 1 REPLY && echo
    REPLY="${REPLY,,}" # To lowercase

    if [[ "$REPLY" =~ ^y ]]; then
        echo "Got confirmation from you. Calling a function..."
        do_something
    else
        echo "No confirmation means nothing to do"
    fi
}

check_confirmation
