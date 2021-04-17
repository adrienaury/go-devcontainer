#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

EXPIRY=3600 # 1 hour
DIR="${HOME}/.curlcache"
mkdir -p "${DIR}"

HASH=$(echo -n "$@" | md5sum | awk '{print $1}')
CACHE="${DIR}/${HASH}"
test -f "${CACHE}" && [ $(expr $(date +%s) - $(date -r "${CACHE}" +%s)) -le ${EXPIRY} ] || curl "$@" > "${CACHE}"
cat "${CACHE}"
