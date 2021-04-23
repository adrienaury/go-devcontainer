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
  echo "Usage:   ${__base} [OPTIONS] [VERSION]"
  echo
  echo "Update docker client to the given version, or the latest"
  echo
  echo "Options:"
  echo "      --install string        Install the script with the given alias"
  echo
  echo "Example: ${__base} v20.10.6"
  echo
  echo "Author: https://github.com/adrienaury"
}

CMD_SHORT_OPTS="h"
CMD_LONG_OPTS="install:,help"

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
# n/a

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

[ $# -eq 0 ] && VERSION=$(dlast docker) || VERSION=$1

if [ ! -e .gocache/docker-${VERSION}.tar.gz ]; then
  id=$(docker create docker:${VERSION})
  docker cp $id:/usr/local/bin/docker - > .gocache/docker-${VERSION}.tar.gz
  docker rm -v $id
fi

tar -C /usr/bin -xf .gocache/docker-${VERSION}.tar.gz