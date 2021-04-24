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
  echo "Usage:   ${__base} [OPTIONS] IMAGE"
  echo
  echo "Retrieve the latest version of a tool by inspecting dockerhub tags, the tool must use semantic versioning"
  echo
  echo "Options:"
  echo "  -r, --repository string     Name of a repository, default: library"
  echo "  -a, --architecture string   Filter on a specific architecture (e.g.: amd64), this can be a regex expression, default: amd64"
  echo "  -o, --os string             Filter on a specific operating system (e.g.: linux), this can be a regex expression, default: linux"
  echo "  -f, --filter string         Filter tags with a regex, default: ^\d+(.\d+)+$"
  echo "  -l, --limit integer         Limit the number of results, this number is counted in hundreds (e.g.: a limit of 1 will return a maximum of 100 results), default: 1"
  echo "  -c, --cache integer         Cache curl result, default: 1 hour (3600)"
  echo "      --install string        Install the script with the given alias"
  echo
  echo "Example: ${__base} alpine"
  echo
  echo "Author: https://github.com/adrienaury"
}

CMD_SHORT_OPTS="r:a:o:f:l:c:h"
CMD_LONG_OPTS="repository:,architecture:,os:,filter:,limit:,cache:,install:,help"

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
REPOSITORY=library
ARCH=amd64
OS=linux
FILTER='^\d\+\(\.\d\+\)\+$'
MAX_PAGES=1
CACHE=3600

while true; do
  case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    --install)
        cp ${__file} /usr/bin/$2
        exit 0
        ;;
    -r|--repository)
        REPOSITORY="$2"
        shift 2
        ;;
    -a|--architecture)
        ARCH="$2"
        shift 2
        ;;
    -o|--os)
        OS="$2"
        shift 2
        ;;
    -f|--filter)
        FILTER="$2"
        shift 2
        ;;
    -l|--limit)
        MAX_PAGES="$2"
        shift 2
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

IMAGE=$1

cache -e ${CACHE} -- dtags -r "${REPOSITORY}" -a "${ARCH}" -o "${OS}" -l "${MAX_PAGES}" -c "${CACHE}" ${IMAGE} \
  | jq --raw-output '.tag' \
  | grep -e ${FILTER} \
  | sort -V \
  | tail -1
