#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"

show_help() {
  echo
  echo "Usage:   ${__base} [OPTIONS] USER/REPO"
  echo
  echo "Retrieve the latest version of a tool by inspecting github releases"
  echo
  echo "Options:"
  echo "  -c, --cache integer         Cache curl result timeout, default: 1 hour (3600)"
  echo "      --install string        Install the script with the given alias"
  echo
  echo "Example: ${__base} cli/cli"
  echo
  echo "Author: https://github.com/adrienaury"
}

CMD_SHORT_OPTS="c:h"
CMD_LONG_OPTS="cache:,install:,help"

! PARSED=$(getopt --options="${CMD_SHORT_OPTS}" --longoptions="${CMD_LONG_OPTS}" --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    show_help
    exit 2
fi

# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# defaults
CACHE=3600

while true; do
  case "$1" in
    h|--help)
        show_help
        exit 0
        ;;
    --install)
        cp ${__file} /usr/bin/$2
        exit 0
        ;;
    -c|--cache)
        CACHE="$2"
        shift 2
        ;;
    --)
        # start of positionnal params
        shift
        break
        ;;
    *)
        echo "program error"
        exit 3
        ;;
  esac
done

[ $# -eq 0 ] && show_help && exit 0

REPO=$1

cache -e ${CACHE} -- curl --silent --header "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/${REPO}/releases/latest" | jq --raw-output ".tag_name"
