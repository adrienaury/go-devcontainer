#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

show_help() {
  echo
  echo "Usage:   ${BASH_SOURCE[0]} [OPTIONS] -- COMMAND"
  echo
  echo "Cache the result of 'COMMAND'"
  echo
  echo "Options:"
  echo "  -e, --expiry integer     Timeout in seconds for the result to be discarded"
  echo
  echo "Example: ${BASH_SOURCE[0]} -- curl -H 'Accept: application/vnd.github.v3+json' https://api.github.com/gists/6e1e9540235e43b28b7d0bc8a8afcc5214c1a3ab"
  echo
  echo "Thanks to https://gist.github.com/adrienaury/4ec61ae619ec7b68e03cf4ee603a0645"
}

CMD_SHORT_OPTS="e:h"
CMD_LONG_OPTS="expiry:,help"

! PARSED=$(getopt --options="${CMD_SHORT_OPTS}" --longoptions="${CMD_LONG_OPTS}" --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    show_help
    exit 2
fi

# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# default expiration for cache: 1 hour
EXPIRY=3600

while true; do
  case "$1" in
    h|--help)
        show_help
        exit 0
        ;;
    -e|--expiry)
        EXPIRY="$2"
        shift 2
        ;;
    --)
        # start of positionnal params
        shift
        break
        ;;
    *)
        echo "should be used like this : ${BASH_SOURCE[0]} [-e <timeout>] -- command ..."
        echo "the double dash is important"
        exit 3
        ;;
  esac
done

[ $# -eq 0 ] && show_help && exit 0

DIR="${HOME}/.cmdcache"
mkdir -p "${DIR}"
HASH=$(echo -n "$@" | md5sum | awk '{print $1}')
CACHE="${DIR}/${HASH}"
(test -f "${CACHE}" && [ $(expr $(date +%s) - $(date -r "${CACHE}" +%s)) -le ${EXPIRY} ] || exec "$@" > "${CACHE}")
cat "${CACHE}"
