#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

curlcache() {
  DIR="${HOME}/.curlcache"
  mkdir -p "${DIR}"
  HASH=$(echo -n "$@" | md5sum | awk '{print $1}')
  CACHE="${DIR}/${HASH}"
  EXPIRY=3600 # 1 hour
  test -f "${CACHE}" && [ $(expr $(date +%s) - $(date -r "${CACHE}" +%s)) -le ${EXPIRY} ] || curl $@ > "${CACHE}"
  cat "${CACHE}"
}

get_all_released_tag() {
  curlcache --silent --header "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$1/$2/releases" | jq ".[0].tag_name"
}

get_latest_released_version() {
  curlcache --silent --header "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$1/$2/releases/latest" | jq --raw-output ".tag_name" | sed -e 's/^v//'
}

print_version() {
  AVAIL=$(get_latest_released_version $2 $3)
  [ "${AVAIL}" == "$4" ] && printf "%-20s %7s ✅\n" "$1" "$4" # ✔️ not working
  [ "$4" == "n/a" ] && printf "%-20s %7s ❌ (latest version is %s)\n" "$1" "$4" "${AVAIL}" && return 0
  [ "${AVAIL}" != "$4" ] && printf "%-20s %7s 🆕 (new version is %s)\n" "$1" "$4" "${AVAIL}" && return 0
  return 0
}

get_githubcli_version() {
  gh --version | head -1 | cut -d' ' -f3 || echo -n "n/a" && return 0
}

get_neon_version() {
  neon --version || echo -n "n/a" && return 0
}

get_golangci_lint_version() {
  golangci-lint --version | cut -d' ' -f4 || echo -n "n/a" && return 0
}

get_goreleaser_version() {
  goreleaser --version | head -1 | cut -d' ' -f3 || echo -n "n/a" && return 0
}

get_svu_version() {
  svu --version 2>&1 | cut -d' ' -f3 || echo -n "n/a" && return 0
}

get_venom_version() {
  venom --version 2>/dev/null | cut -d' ' -f3 || echo -n "n/a" && return 0
}

figlet -c Go Devcontainer

echo
echo   "Installed tools"
echo   "============================================================================="
print_version "Github CLI" "cli" "cli" "$(get_githubcli_version)"
print_version "Neon" "c4s4" "neon" "$(get_neon_version)"
print_version "GolangCI Lint" "golangci" "golangci-lint" "$(get_golangci_lint_version)"
print_version "GoReleaser" "goreleaser" "goreleaser" "$(get_goreleaser_version)"
print_version "SVU" "caarlos0" "svu" "$(get_svu_version)"
print_version "Venom" "ovh" "venom" "$(get_venom_version)"
echo   "============================================================================="
echo
