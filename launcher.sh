#!/usr/bin/env bash

# Configure the environment and launch an application.
#
# This script configures the environment as required for an application, adding
# all sorts of things commonly used with customized environments such as new
# PATH directories and new shared libraries to be loaded. Then, a program which
# has the same name as this script is launched.
#
# The launcher script should be placed in the same directory where the target
# application is located.
#
# Notes:
# * "$@" expands to a list of this script's arguments.
# * "${VAR:-0}" expands to VAR if set, or to "0" if VAR is empty or unset.

# Bash options for strict error checking
set -o errexit -o errtrace -o pipefail -o nounset

# Exit trap -- Runs at the end or, thanks to "errexit", upon any error
on_exit() {
    { _RC="$?"; set +x; } 2>/dev/null
    if ((_RC)); then echo "ERROR ($_RC)"; else echo "SUCCESS"; fi
}
trap on_exit EXIT

# Self path
SELF_PATH="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)" # Absolute canonical path
SELF_FILE="$(basename "${BASH_SOURCE[0]}")" # File name
SELF_NAME="${SELF_FILE%.*}"                 # File name without extension

# Full path to the target application
APP_PATH="${SELF_PATH}/${SELF_NAME}"

# Generate a dummy application, for demonstration purposes
if [[ ! -f "$APP_PATH" ]]; then
    tee "$APP_PATH" >/dev/null <<'EOF'
#!/usr/bin/env sh
echo "    I'm the application!"
echo "    Myself: $0"
echo "    App Argument 1: $1"
echo "    App Argument 2: $2"
EOF
    chmod +x "$APP_PATH"
    APP_PATH_DELETE=1
fi

# Configure some example libraries
export QTDIR="/opt/Qt-custom-build"
export PATH="$QTDIR/bin:${PATH:-}"
export PKG_CONFIG_PATH="$QTDIR/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
export XDG_DATA_DIRS="$QTDIR/share:${XDG_DATA_DIRS:-}"

# Launch target
echo "Launch the application: '$APP_PATH'"
"$APP_PATH" "$@"

# Remove the dummy test application
(( ${APP_PATH_DELETE:-0} )) && rm "$APP_PATH"
