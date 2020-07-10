#!/usr/bin/env bash

# Snippet: Use the "heredoc" shell feature to run in-place Docker commands.
# With this technique, all those "works for me" issues will dissappear!

# Bash options for strict error checking
set -o errexit -o errtrace -o pipefail -o nounset
shopt -s inherit_errexit 2>/dev/null || true

# Exit trap -- Runs at the end or, thanks to "errexit", upon any error
on_exit() {
    { _RC="$?"; set +x; } 2>/dev/null
    if ((_RC)); then echo "ERROR ($_RC)"; else echo "SUCCESS"; fi
}
trap on_exit EXIT



# In-place Docker container commands -- BEGIN
docker run --rm -i ubuntu:18.04 /bin/bash <<'DOCKERCOMMANDS'

# Your commands here

echo "This is the Docker container running"

# Get Ubuntu version definitions. This brings variables such as:
#     DISTRIB_CODENAME="bionic"
#     DISTRIB_RELEASE="18.04"
#
# The file is "/etc/lsb-release" in vanilla Ubuntu installations, but
# "/etc/upstream-release/lsb-release" in Ubuntu-derived distributions
source /etc/upstream-release/lsb-release 2>/dev/null || source /etc/lsb-release
echo
echo "Ubuntu version: $DISTRIB_RELEASE"

echo
echo "Install some packages..."
apt-get -q update && apt-get -q install --no-install-recommends --yes \
    git \
    htop \
    tree

echo
echo "Show what is the Maven version that is available in this Ubuntu:"
apt-cache policy maven

# If you run `ssh` commands, they must go with '-n':
# ssh -n <MyHost> '<MyRemoteCommand>'

echo
echo "Done running commands in the Docker container!"

DOCKERCOMMANDS
# In-place Docker container commands -- END
