#!/usr/bin/env bash
# Checked with ShellCheck (https://www.shellcheck.net/)

#/ Use the "heredoc" shell feature to run in-place Docker commands.
#/ With this technique, all those "works for me" issues will dissappear!

# Shell setup.
source "bash.conf.sh" || { echo "Cannot load Bash config file"; exit 1; }

# Trace all commands (to stderr).
#set -o xtrace



# Heredoc
# =======

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
