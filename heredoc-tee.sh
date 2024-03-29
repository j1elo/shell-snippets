#!/usr/bin/env bash
# Checked with ShellCheck (https://www.shellcheck.net/)

#/ Use the "heredoc" shell feature to create a file in-place.
#/
#/ This technique can be used with any command that accepts input, but the nice
#/ thing about `tee` is that it allows creating root files with just adding
#/ `sudo` at the very start of the command, which matches the typical structure
#/ of how `sudo` commands are usually called (easier for beginners).
#/
#/ Note: Using single quotation marks, as in 'EOF', is used to prevent the shell
#/ from performing any kind of wildcard expansion or variable substitution.
#/
#/ Note: `tee` by itself will replace the file. If you want to _append_ to an
#/ already existing file, use `tee --append`.

# Shell setup.
source "bash.conf.sh" || { echo "Cannot load Bash config file"; exit 1; }

# Trace all commands (to stderr).
#set -o xtrace

# Create a temp file used for the heredoc example
TEMP_FILE="$(mktemp)"

sudo tee "$TEMP_FILE" >/dev/null <<'EOF'
This is a new file. You can put here all contents you want.
But note that THESE LINES SHOULD NOT BE INDENTED. Otherwise any indentation you
use will end up in the file itself.

If you use <<EOF (without single quotes) then all variables will be expanded.
If you use <<'EOF' (notice the single quotes) then all variables will be left
verbatim in the generated file.

This example uses <<'EOF', so this variable should not be expanded and should
appear as-is: $SOME_VARIABLE.

Also note that you can use any word you want instead of "EOF". For example you
could use "MYCOMMANDS" or similar. Just make sure the same word is used in the
beginning and end of this heredoc section.
EOF

echo "The heredoc file is here: '$TEMP_FILE'"
echo
echo "The heredoc file contents are:"
echo
cat "$TEMP_FILE"
echo
echo "Example finished!"

# Delete the temp file to leave the system clean
rm "$TEMP_FILE"
