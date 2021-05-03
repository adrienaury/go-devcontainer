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
  echo "Usage:   ${__base} [OPTIONS] -- COMMAND"
  echo
  echo "Cache the result of 'COMMAND'"
  echo
  echo "Options:"
  echo "  -e, --expiry integer     Timeout in seconds for the result to be discarded"
  echo "  -d, --delete             Delete cache data associated with the command"
  echo "      --install string     Install the script with the given alias"
  echo
  echo "Example: ${__base} -- curl -H 'Accept: application/vnd.github.v3+json' https://api.github.com/gists/4ec61ae619ec7b68e03cf4ee603a0645"
  echo
  echo "Thanks to https://gist.github.com/adrienaury/4ec61ae619ec7b68e03cf4ee603a0645"
}

CMD_SHORT_OPTS="e:dh"
CMD_LONG_OPTS="expiry:,delete,install:,help"

! PARSED=$(getopt --options="${CMD_SHORT_OPTS}" --longoptions="${CMD_LONG_OPTS}" --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    show_help
    exit 2
fi

# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# contants
DIR="${HOME}/.cmdcache"

# default expiration for cache: 1 hour
EXPIRY=3600
DELETE=false

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
    -d|--delete)
        DELETE=true
        shift
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
        echo "should be used like this : ${__base} [-e <timeout>] -- command ..."
        echo "the double dash is important"
        exit 3
        ;;
  esac
done

[ $# -eq 0 ] && show_help && exit 0

mkdir -p "${DIR}"
HASH=$(echo -n "$@" | md5sum | awk '{print $1}')
CACHE="${DIR}/${HASH}"
if [ "${DELETE}" == "true" ]; then
    rm -f ${CACHE}
else
    (test -f "${CACHE}" && [ $(expr $(date +%s) - $(date -r "${CACHE}" +%s)) -le ${EXPIRY} ] && cat "${CACHE}" || exec "$@" | tee "${CACHE}")
fi
