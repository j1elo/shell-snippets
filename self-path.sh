#!/usr/bin/env bash
# Checked with ShellCheck (https://www.shellcheck.net/)

#/ Get path components of the running script.
#/
#/ This script finds out all components of its own path, and prints each one
#/ separately. It also shows the difference between "$0" and "${BASH_SOURCE[0]}".
#/
#/ Features:
#/ * Handles all path names, even those that start with a hyphen ("-").
#/ * Doesn't require `readlink` or `realpath` to be installed.
#/
#/ Sources:
#/ * https://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script-in-bash/17744637#17744637
#/ * https://stackoverflow.com/questions/35006457/choosing-between-0-and-bash-source/55798664#55798664

# Shell setup.
source "bash.conf.sh" || { echo "Cannot load Bash config file"; exit 1; }

# Trace all commands (to stderr).
#set -o xtrace



# Self path
# =========

echo "Working Directory: $PWD"

# Absolute Canonical Path to the directory that contains this script.
# * Always quote everything, to allow for spaces in directory names.
# * Always pass arguments after `--`, to allow names starting with `-`.
# * Use "${BASH_SOURCE[0]}", which is more reliable than "$0" because it also
#   works when this file is being sourced from other script.
# * Use `-P`, to follow symlinks into the actual path they link to.
# * Discard output from `cd`, in case "$CDPATH" is set.
SELF_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd -P)"

# Components of this script's file name.
SELF_FILE="$(basename "${BASH_SOURCE[0]}")" # File name.
SELF_NAME="${SELF_FILE%.*}"                 # File name without extension.
SELF_EXT="${SELF_FILE##*.}"                 # File extension.

echo "Self dir and file:"
echo "\$0:                '$0'"
echo "\${BASH_SOURCE[0]}: '${BASH_SOURCE[0]}'"
echo "\$SELF_DIR:         '$SELF_DIR'"
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
echo "...calling SCRIPT_C by name:"
"$SCRIPT_B_CALL"
echo
echo "...sourcing SCRIPT_C contents:"
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
echo "\${BASH_SOURCE[0]}:  '${BASH_SOURCE[0]:-}'"
echo "\${BASH_SOURCE[1]}:  '${BASH_SOURCE[1]:-}'"
echo "\${BASH_SOURCE[2]}:  '${BASH_SOURCE[2]:-}'"
echo "\${BASH_SOURCE[-1]}: '${BASH_SOURCE[-1]:-}' (last item in array)"
echo "\$0:                 '$0'"
EOF
chmod +x "$SCRIPT_C"

# shellcheck disable=SC2016
echo "Difference between \$0 and \${BASH_SOURCE[0]} when..."
echo ""

"$SCRIPT_A"

echo ""
echo "Conclusions:"
echo "* \$0 gives the topmost name when sourcing scripts into others."
echo "* \${BASH_SOURCE[n]} gives every individual sourcing file names."

# Cleanup.
rm "$SCRIPT_A" "$SCRIPT_B_CALL" "$SCRIPT_B_SOURCE" "$SCRIPT_C"
echo
