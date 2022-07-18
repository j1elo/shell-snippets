#!/usr/bin/env bash
# Checked with ShellCheck (https://www.shellcheck.net/)

#/ Parse command line arguments using the `getopts` Bash builtin.
#/
#/ Note: The leading colon (":") in the `getopts` definition list enables the
#/ "silent error reporting mode", which allows us to handle the error in case of
#/ unexpected arguments.
#/
#/ Note: `getopts` is nice, but has the limitation of only handling short style
#/ options, i.e. "-o" instead of "--option". To have support for long options,
#/ consider either using GNU getopt(3), or the traditional method based on
#/ manually parsing arguments with a "while + case + shift" loop.
#/
#/ Sample usage:
#/     ./getopts.sh -a
#/     ./getopts.sh -ab
#/     ./getopts.sh -b -f "file1 file2 file3" -v
#/     ./getopts.sh -n
#/
#/ Sources:
#/ * http://wiki.bash-hackers.org/howto/getopts_tutorial
#/ * https://google.github.io/styleguide/shell.xml

# Shell setup.
source "bash.conf.sh" || { echo "Cannot load Bash config file"; exit 1; }

# Trace all commands (to stderr).
#set -o xtrace



# Parse call arguments
# ====================

# Convert call arguments into configuration variables that would be used later
# during the script execution.

CFG_A="false"
CFG_B="false"
CFG_FILES=""
CFG_VERBOSE=0

while getopts ':abf:v' OPT; do
    case "$OPT" in
        a) CFG_A="true" ;;
        b) CFG_B="true" ;;
        f) CFG_FILES="$OPTARG" ;;
        v) CFG_VERBOSE=1 ;;
        ?) echo "Unexpected argument: '${OPTARG:-}'" ;;
        *) ;;
    esac
done

echo
echo "Parsed arguments:"
echo "Flag 'a': $CFG_A"
echo "Flag 'b': $CFG_B"
echo "Files: [ $CFG_FILES ]"
(( CFG_VERBOSE )) && echo "Verbose level: $CFG_VERBOSE"
