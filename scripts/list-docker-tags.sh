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
  echo "Retrieve a list of tags from dockerhub"
  echo
  echo "Options:"
  echo "  -r, --repository string     Name of a repository, default: library"
  echo "  -a, --architecture string   Filter on a specific architecture (e.g.: amd64), this can be a regex expression, default: all architectures"
  echo "  -o, --os string             Filter on a specific operating system (e.g.: linux), this can be a regex expression, default: linux"
  echo "  -l, --limit integer         Limit the number of results, this number is counted in hundreds (e.g.: a limit of 1 will return a maximum of 100 results), default to 10"
  echo "  -c, --cache integer         Cache curl result, default no caching"
  echo
  echo "Example: ${__base} -l1 -a amd64 alpine"
  echo
  echo "Inspired by https://gist.github.com/bric3"
  echo "Adapted by https://gist.github.com/adrienaury"
}

CMD_SHORT_OPTS="r:a:o:l:c:h"
CMD_LONG_OPTS="repository:,architecture:,os:,limit:,cache:,help"

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
ARCH=".*" # all architectures
OS=linux
MAX_PAGES=10
CACHE=0

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
    -a|--architecture)
        ARCH="$2"
        shift 2
        ;;
    -o|--os)
        OS="$2"
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

(
  url="https://registry.hub.docker.com/v2/repositories/${REPOSITORY}/${IMAGE}/tags/?page_size=100"
  counter=1
  while [ $counter -le ${MAX_PAGES} ] && [ -n "${url}" ]; do
    if [ ${CACHE} -eq 0 ]; then
      content=$(curl --silent "${url}")
    else
      content=$(cache -e ${CACHE} -- curl --silent "${url}")
    fi
    ((counter++))
    url=$(jq -r '.next // empty' <<< "${content}")
    echo -n "${content}"
  done
) | jq -s '[.[].results[]]' \
  | jq 'map({tag: .name, date: .last_updated, image: .images[] | select(.architecture|match("'${ARCH}'")) | select(.os|match("'${OS}'"))}) | map({tag: .tag, date: .date, os: .image.os, architecture: .image.architecture, digest: .image.digest}) | unique | sort_by(.tag)' \
  | jq -c '.[]';
