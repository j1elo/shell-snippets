#!/usr/bin/env bash
set -eu -o pipefail  # Abort on errors, disallow undefined variables

# Use `tee` and "heredoc syntax" to write a system file.
#
# With this construction, an unprivileged user can create a new system file,
# using `sudo` for gaining the required file write privileges.
#
# Notes:
# - Using single quotation marks, as in 'EOF', is used to prevent the shell
#   from performing any kind of wildcard substitution or variable expansions.
#
# Changes:
# 2017-10-03 Juan Navarro <juan.navarro@gmx.es>
# - Initial version.

sudo tee "/tmp/system_file" > /dev/null <<'EOF'
# UniKey rule for Udev (tested in Ubuntu 12.04 & 14.04)
ATTRS{idVendor}=="0403", ATTRS{idProduct}=="c580", MODE="0666"
EOF

# ------------

echo ""
echo "[$0] Done."
