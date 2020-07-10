#!/usr/bin/env bash

# Parse command line arguments using the `getopts` Bash builtin.
#
# Note: The leading colon (":") in the `getopts` definition list enables the
# "silent error reporting mode", which allows us to handle the error in case of
# unexpected arguments.
#
# Note: `getopts` is nice, but has the limitation of only handling short style
# options, i.e. "-o" instead of "--option". To have support for long options,
# consider either using GNU getopt(3), or the traditional method based on
# manually parsing arguments with a "while + case + shift" loop.
#
# Sample usage:
#     ./getopts.sh -a
#     ./getopts.sh -ab
#     ./getopts.sh -b -f "file1 file2 file3" -v
#     ./getopts.sh -n
#
# Sources:
# * http://wiki.bash-hackers.org/howto/getopts_tutorial
# * https://google.github.io/styleguide/shell.xml

# Bash options for strict error checking
set -o errexit -o errtrace -o pipefail -o nounset
shopt -s inherit_errexit 2>/dev/null || true

ARG_A="false"
ARG_B="false"
ARG_FILES=""
ARG_VERBOSE=0

while getopts ':abf:v' OPT; do
    case "$OPT" in
        a) ARG_A="true" ;;
        b) ARG_B="true" ;;
        f) ARG_FILES="$OPTARG" ;;
        v) ARG_VERBOSE=1 ;;
        ?) echo "Unexpected argument: '${OPTARG:-}'" ;;
        *) ;;
    esac
done

echo
echo "Parsed arguments:"
echo "Flag 'a': $ARG_A"
echo "Flag 'b': $ARG_B"
echo "Files: [ $ARG_FILES ]"
(( $ARG_VERBOSE )) && echo "Verbose level: $ARG_VERBOSE"
