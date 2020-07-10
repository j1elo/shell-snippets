#!/usr/bin/env bash

# Get the running script's file path.
#
# This script finds out all components of its own path, and prints each one
# separately. It also shows the difference between "$0" and "${BASH_SOURCE[0]}".
#
# Notes:
# * Handles all path names, even those that start with a hyphen ("-").
# * Doesn't require `readlink` or `realpath` to be installed.
#
# Sources:
# * https://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script-in-bash/17744637#17744637
# * https://stackoverflow.com/questions/35006457/choosing-between-0-and-bash-source/55798664#55798664

# Bash options for strict error checking
set -o errexit -o errtrace -o pipefail -o nounset

echo "Working Directory: $PWD"
echo



# Self path
# =========

SELF_PATH="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)" # Absolute canonical path
SELF_FILE="$(basename "${BASH_SOURCE[0]}")" # File name
SELF_NAME="${SELF_FILE%.*}"                 # File name without extension
SELF_EXT="${SELF_FILE##*.}"                 # File extension

echo "Self path and name:"
echo "\${BASH_SOURCE[0]}: '${BASH_SOURCE[0]}'"
echo "\$SELF_PATH:        '$SELF_PATH'"
echo "\$SELF_FILE:        '$SELF_FILE'"
echo "\$SELF_NAME:        '$SELF_NAME'"
echo "\$SELF_EXT:         '$SELF_EXT'"
echo



# Difference between "$0" and "${BASH_SOURCE[0]}"
# ===============================================

SCRIPT_A="$(mktemp --tmpdir "SCRIPT_A.tmp_XXX")"
SCRIPT_B_CALL="$(mktemp --tmpdir "SCRIPT_B_CALL.tmp_XXX")"
SCRIPT_B_SOURCE="$(mktemp --tmpdir "SCRIPT_B.tmp_XXX")"
SCRIPT_C="$(mktemp --tmpdir "SCRIPT_C.tmp_XXX")"

tee "$SCRIPT_A" >/dev/null <<EOF
#!/usr/bin/env bash
echo "Calling scripts by name:"
"$SCRIPT_B_CALL"
echo
echo "Sourcing script contents:"
source "$SCRIPT_B_SOURCE"
EOF
chmod +x "$SCRIPT_A"

tee "$SCRIPT_B_CALL" >/dev/null <<EOF
#!/usr/bin/env bash
"$SCRIPT_C"
EOF
chmod +x "$SCRIPT_B_CALL"

tee "$SCRIPT_B_SOURCE" >/dev/null <<EOF
#!/usr/bin/env bash
source "$SCRIPT_C"
EOF

tee "$SCRIPT_C" >/dev/null <<'EOF'
#!/usr/bin/env bash
echo "\$0:                '$0'"
echo "\${BASH_SOURCE[0]}: '${BASH_SOURCE[0]}'"
echo "\${BASH_SOURCE[1]}: '${BASH_SOURCE[1]:-}'"
echo "\${BASH_SOURCE[2]}: '${BASH_SOURCE[2]:-}'"
EOF
chmod +x "$SCRIPT_C"

# shellcheck disable=SC2016
echo 'Difference between "$0" and "${BASH_SOURCE[0]}":'
echo
"$SCRIPT_A"
rm "$SCRIPT_A" "$SCRIPT_B_CALL" "$SCRIPT_B_SOURCE" "$SCRIPT_C"
echo
