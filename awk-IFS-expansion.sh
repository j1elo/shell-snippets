#!/usr/bin/env bash
# Checked with ShellCheck (https://www.shellcheck.net/)

#/ Example of how to use awk to extract parts of lines in a text file.
#/ This showcases both the awk and IFS field separators.

# Shell setup.
source "bash.conf.sh" || { echo "Cannot load Bash config file"; exit 1; }

# Trace all commands (to stderr).
#set -o xtrace



# Example input
# =============

tee /tmp/test >/dev/null <<'EOF'
\includegraphics[width=\textwidth]{img/apps/webapp-1.png}
\includegraphics[width=\textwidth]{img/apps/webapp-2.png}
\includegraphics[width=\textwidth]{img/apps/webapp-3.png}
\includegraphics[width=\textwidth]{img/webapp-1-branches-graph.png}
    \includegraphics[width=\textwidth]{img/dir with spaces/webapp-1-regression-2.png}
    \includegraphics[width=\textwidth]{img/dir with spaces/webapp-2-regression-1.png}
    \includegraphics[width=\textwidth]{img/dir with spaces/webapp-2-regression-2.png}
    \includegraphics[width=\textwidth]{img/dir with spaces/webapp-2-regression-3.png}
    \includegraphics[width=\textwidth]{img/dir with spaces/webapp-3-regression-1.png}
\includegraphics[width=10cm]{img/file with spaces 1.png}
\includegraphics[width=\textwidth]{img/file with spaces 2.png}
\includegraphics[width=\textwidth]{img/file with spaces 3.png}
\includegraphics[width=\textwidth]{img/file with spaces 4.png}
EOF



# awk command
# ===========

# Base command: read as CSV-style with '{' and '}' as separators.
# `-F` accepts a regex as value. Use the "any of" syntax (square brackets).
awk -F[{}] '{print $2}' /tmp/test



# IFS separation
# ==============

# IFS contains the set of characters that the shell uses for string splitting.
#
# By default, IFS contains whitespace: ' ', '\t', '\n'.
#
# By setting IFS to only newlines, the shell will treat strings with spaces
# as a single unit, instead of breaking them into words.
#
# To set a shell variable with an escaped character '\c', the syntax is `$'\c'`.

# Store awk output into a Bash array.
# Set IFS to only split at newlines (avoid splitting at spaces).
# shellcheck disable=SC2207 # IFS set so word splitting works the intended way.
IFS=$'\n' IMG_PATHS=($(awk -F[{}] '{print $2}' /tmp/test))

# Iterate over all items of the Bash array.
for IMG_PATH in "${IMG_PATHS[@]}"; do
    # Get path components with Bash substring removal:
    # https://wiki-dev.bash-hackers.org/syntax/pe#substring_removal
    IMG_DIR="${IMG_PATH%/*}"
    IMG_FILE="${IMG_PATH##*/}"

    echo "Image path: <$IMG_PATH>"
    echo "Image dir: <$IMG_DIR>"
    echo "Image file: <$IMG_FILE>"
    echo ""
done
