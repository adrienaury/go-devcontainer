#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

show_help() {
  echo
  echo "Usage:   ${BASH_SOURCE[0]} [OPTIONS] IMAGE"
  echo
  echo "Retrieve a list of tags from dockerhub"
  echo
  echo "Options:"
  echo "  -r, --repository string Name of a repository"
  echo
  echo "Example: ${BASH_SOURCE[0]} -l 10 alpine"
  echo
  echo "Thanks to https://gist.github.com/adrienaury/4ec61ae619ec7b68e03cf4ee603a0645"
}

CMD_SHORT_OPTS="r:h"
CMD_LONG_OPTS="repository:,help"

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
PAGE_SIZE=50
MAX_PAGES=10

while true; do
  case "$1" in
    h|--help)
        show_help
        exit 0
        ;;
    -r|--repository)
        REPOSITORY="$2"
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

(
  url="https://registry.hub.docker.com/v2/repositories/${REPOSITORY}/${IMAGE}/tags/?page_size=${PAGE_SIZE}"
  counter=1
  while [ $counter -le ${MAX_PAGES} ] && [ -n "${url}" ]; do
    content=$(curl --silent "${url}");
    ((counter++));
    url=$(jq -r '.next // empty' <<< "${content}");
    echo -n "${content}";
  done;
) | jq;
