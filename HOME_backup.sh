#!/usr/bin/env bash
set -eu -o pipefail  # Abort on errors, disallow undefined variables

# Backup a selection of user settings from $HOME.
#
# This script keeps an updated copy of all specified $FILES
# in the $DST_PATH folder.
#
# Notes:
# - `read -p` is a Bash built-in.
#
# Changes:
# 2017-10-03 Juan Navarro <juan.navarro@gmx.es>
# - Initial version.

# Settings
DST_PATH="./HOME_BACKUP"

COMMAND="rsync -av -RC --exclude-from=- --delete --delete-excluded"

FILES="
$HOME/.config/Code/User/*.json
$HOME/.config/QtProject/*.ini
$HOME/.config/QtProject/qtcreator/codestyles/Cpp
$HOME/.config/ShowKube
$HOME/.config/Slack
$HOME/.config/autostart/redshift-gtk.desktop
$HOME/.config/bleachbit
$HOME/.config/chromium
$HOME/.config/digikamrc
$HOME/.config/geany
$HOME/.config/kate*
$HOME/.config/monitors.xml
$HOME/.config/qBittorrent
$HOME/.config/quassel-irc.org
$HOME/.config/quasselrc
$HOME/.config/redshift.conf
$HOME/.config/user-dirs.dirs
$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
$HOME/.local/share/kxmlgui5/kate/kateui.rc
$HOME/.local/share/kxmlgui5/katepart/katepart5ui.rc
$HOME/.bash_aliases
$HOME/.gitconfig
$HOME/.mozilla
$HOME/.profile
$HOME/.profile_fns
$HOME/.ssh
$HOME/.subversion
$HOME/.thunderbird
$HOME/.vscode
$HOME/bin
"

EXCLUDES="
.config/Slack/Cache
.config/Slack/logs
.config/chromium/Crash Reports
.config/chromium/Default/Application Cache
.config/chromium/Default/GPUCache
.config/chromium/Default/WebRTC Logs
.mozilla/firefox/Crash Reports
.mozilla/firefox/jqcad2z2.default/bookmarkbackups
.mozilla/firefox/jqcad2z2.default/crashes
.mozilla/firefox/jqcad2z2.default/datareporting
.mozilla/firefox/jqcad2z2.default/saved-telemetry-pings
.mozilla/firefox/jqcad2z2.default/sessionstore-backups
.thunderbird/Crash Reports
.thunderbird/z7hsz0z1.default/crashes
.thunderbird/z7hsz0z1.default/datareporting
.thunderbird/z7hsz0z1.default/minidumps
.thunderbird/z7hsz0z1.default/saved-telemetry-pings
"

echo "==== Update user settings backup ===="
echo "This script should be run from ${DST_PATH}/../"
echo
read -p "Are you sure? Type 'yes': " -r SURE
if [ "$SURE" = "yes" ] || [ "$SURE" = "YES" ]; then
  [ -d "$DST_PATH" ] || { echo "I said: THIS SCRIPT SHOULD BE RUN FROM ${DST_PATH}/../"; exit 1; }

  echo "Working ..."

  for f in $FILES; do
    if [ -e "$f" ]; then
      echo "$EXCLUDES" | $COMMAND "$f" "${DST_PATH}/"
    fi
  done
fi

echo ""
echo "Backup prepared into ${DST_PATH}/"

# ------------

echo ""
echo "[$0] Done."
