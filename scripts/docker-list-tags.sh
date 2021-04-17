#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"

curlcache() {
  sh $__dir/curlcache.sh "$@"
}

image=${1};

max_pages=10;

(
  url="https://registry.hub.docker.com/v2/repositories/library/${image}/tags/?page_size=200"
  counter=1
  while [ $counter -le $max_pages ] && [ -n "${url}" ]; do
    content=$(curlcache --silent "${url}");
    ((counter++));
    url=$(jq -r '.next // empty' <<< "${content}");
    echo -n "${content}";
  done;
) | jq -s '[.[].results[]]' \
  | jq 'map({tag: .name, image: .images[] | select(.architecture == "amd64")}) | map({tag: .tag, digest: .image.digest}) | unique' \
  | jq -c '.[]';
