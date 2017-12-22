#!/usr/bin/env bash
set -eu -o pipefail  # Abort on errors, disallow undefined variables
IFS=$'\n\t'          # Apply word splitting only on newlines and tabs

# Template shell script with samples of all best practices.
#
# Source:
# - https://dev.to/thiht/shell-scripts-matter

#/ Usage: "./$0"
#/ Description:
#/ Examples:
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c 4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

# Set up logging functions
readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]  $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARN]  $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR] $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL] $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

# Set up trap functions
on_error() {
  error "ERROR"
}
trap on_error ERR

on_exit() {
  # Remove temporary files
  # Restart services
  # ------------
  info "[$0] Done."
}
trap on_exit EXIT

# ---- Script start ----
info "Script running: [$0]"
