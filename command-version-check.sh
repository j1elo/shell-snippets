#!/usr/bin/env bash
# Checked with ShellCheck (https://www.shellcheck.net/)

#/ Check if a command is installed and if its version is high enough.

# Shell setup.
source "bash.conf.sh" || { echo "Cannot load Bash config file"; exit 1; }

# Trace all commands (to stderr).
set -o xtrace



# Settings
# ========

# This could be a real use case for the commands shown here:
#
# COMMAND="clang"
# COMMAND_ARG="--version"
# VERSION_REQ="9.0.1"

# However for demonstration purposes, and in order to not depend on Clang,
# we'll use dummy strings that prove how the version extraction works.
#
COMMAND="echo"
# COMMAND_ARG="This is version 111.222ABC -- More text"
COMMAND_ARG="This is version 111.221.333ABC -> More text"
# COMMAND_ARG="This is version 111.222.333.4.5 (More text)"
VERSION_REQ="111.222.0"



# Check command
# =============

# Check if the requested command is installed and available in the environment
if ! command -v "$COMMAND" >/dev/null; then
    log "Command '$COMMAND' is not installed in the system"
    exit 1
fi

# Get the command output
COMMAND_STR="$("$COMMAND" "$COMMAND_ARG")"
log "Command output (raw string): '$COMMAND_STR'"

# Parse the program version number.
# Note that in this regex, we let the PATCH number to be optional.
# So, the program version might be "1.2" or "1.2.3".
# This can be important, depending on the kind of processing to be done later.
VERSION_STR="$(echo "$COMMAND_STR" | grep -Po '(\d+\.\d+(\.\d+)?)' | head -1)"

# An alternative with Perl (which is anyway installed in most systems)
# VERSION_STR="$(echo "$COMMAND_STR" | perl -ne '/(\d+\.\d+(\.\d+)?)/ && print $1')"

log "Command version (parsed): '$VERSION_STR'"

# (Optional) Break the version into its individual components
VERSION_MAJ="$(echo "$VERSION_STR" | cut -d. -f1)"
VERSION_MIN="$(echo "$VERSION_STR" | cut -d. -f2)"
VERSION_FIX="$(echo "$VERSION_STR" | cut -d. -f3)"
VERSION_FIX="${VERSION_FIX:-0}" # IN this example, Patch is optional so maybe there was none.
log "Version components: '$VERSION_MAJ', '$VERSION_MIN', '$VERSION_FIX'"

# This function returns an integer number which has filled in all its possible
# version components (Major.Minor.Patch.Other), up to a maximum of 4.
# E.g. it converts a component of "1" into "001", or "0" into "000".
function version_int {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}

if [[ $(version_int "$VERSION_STR") -ge $(version_int "$VERSION_REQ") ]]; then
    log "Version '$VERSION_STR' >= '$VERSION_REQ', all OK"
else
    log "Version '$VERSION_STR' < '$VERSION_REQ', NOT OK"
fi

log "Done!"
