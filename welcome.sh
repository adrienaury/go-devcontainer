#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

get_all_released_tag() {
    curl --silent --header "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$1/$2/releases" | jq ".[0].tag_name"
}

get_latest_released_version() {
  curl --silent --header "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$1/$2/releases/latest" | jq --raw-output ".tag_name" | sed -e 's/^v//'
}

printf "Github CLI    : %-20s %-20s\n" "installed=${GITHUBCLI_VERSION}" "available=$(get_latest_released_version cli cli)"
printf "Neon          : %-20s %-20s\n" "installed=${NEON_VERSION}" "available=$(get_latest_released_version c4s4 neon)"
printf "GolangCI Lint : %-20s %-20s\n" "installed=${GOLANGCI_LINT_VERSION}" "available=$(get_latest_released_version golangci golangci-lint)"
printf "GoReleaser    : %-20s %-20s\n" "installed=${GORELEASER_VERSION}" "available=$(get_latest_released_version goreleaser goreleaser)"
printf "SVU           : %-20s %-20s\n" "installed=${SVU_VERSION}" "available=$(get_latest_released_version caarlos0 svu)"
