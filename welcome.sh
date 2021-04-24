#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

print_version() {
  AVAIL=$(glast $2/$3 | sed -e 's/^.*v//')
  ALIAS=${5:-$3}
  [ "${AVAIL}" == "$4" ] && printf "├── %-15s %10s ✅\n" "$1" "$4" # ✔️ not working
  [ "$4" == "n/a" ] && printf "├── %-15s %10s ❌ run 'sudo instool ${ALIAS} ${AVAIL}' to install latest version\n" "$1" "$4" && return 0
  [ "${AVAIL}" != "$4" ] && printf "├── %-15s %10s 🆕 run 'sudo instool ${ALIAS} ${AVAIL}' to update to latest version\n" "$1" "$4" && return 0
  return 0
}

get_githubcli_version() {
  gh --version 2>/dev/null | head -1 | cut -d' ' -f3 || echo -n "n/a" && return 0
}

get_neon_version() {
  neon --version 2>/dev/null || echo -n "n/a" && return 0
}

get_golangci_lint_version() {
  golangci-lint --version 2>/dev/null | cut -d' ' -f4 || echo -n "n/a" && return 0
}

get_goreleaser_version() {
  goreleaser --version 2>/dev/null | head -1 | cut -d' ' -f3 || echo -n "n/a" && return 0
}

get_svu_version() {
  if svu --version >/dev/null 2>&1; then
    svu --version 2>&1 >/dev/null | cut -d' ' -f3
    return 0
  fi
  echo "n/a"
}

get_venom_version() {
  venom version 2>/dev/null | cut -d' ' -f3 | sed -e 's/^v//' || echo -n "n/a" && return 0
}

get_gopls_version() {
  gopls version 2>/dev/null | head -1 | cut -d' ' -f2 | sed -e 's/^v//' || echo -n "n/a" && return 0
}

get_delve_version() {
  dlv version 2>/dev/null | head -2 | tail -1 | cut -d' ' -f2 | sed -e 's/^v//' || echo -n "n/a" && return 0
}

get_changie_version() {
  changie -v 2>/dev/null | cut -d' ' -f3 | sed -e 's/^v//' || echo -n "n/a" && return 0
}

get_gopkgs_version() {
  cat ~/.gopkgs
}

get_goplay_version() {
  cat ~/.goplay
}

get_gomodifytags_version() {
  cat ~/.gomodifytags
}

figlet -c Go Devcontainer

(
  source /etc/os-release
  printf "%-14s %15s " "${NAME}" "v${VERSION_ID}"
  LATEST_ALPINE_VERSION=$(dlast alpine)
  [[ "${LATEST_ALPINE_VERSION}" == "${VERSION_ID}" ]] && echo "✅" || echo "🆕 new alpine version available v${LATEST_ALPINE_VERSION}"
)

DOCKER_CLI_VERSION=$(docker version -f '{{.Client.Version}}' 2>/dev/null || :)
DOCKER_CLI_VERSION_LATEST=$(dlast docker)
printf "├── %-15s %10s " "Docker Client" "v${DOCKER_CLI_VERSION}"
[[ "${DOCKER_CLI_VERSION_LATEST}" == "${DOCKER_CLI_VERSION}" ]] && echo "✅" || echo "🆕 new version available v${DOCKER_CLI_VERSION_LATEST}, run 'dockerup' to update"

GIT_VERSION=$(git --version | cut -d' ' -f3 || :)
GIT_VERSION_LATEST=$(dlast -f '^v\d\+\(\.\d\+\)\+$' -r alpine git | sed -e 's/^v//')
printf "├── %-15s %10s " "Git Client" "v${GIT_VERSION}"
[[ "${GIT_VERSION_LATEST}" == "${GIT_VERSION}" ]] && echo "✅" || echo "🆕 new version available v${GIT_VERSION_LATEST}, run 'gitup' to update"

ZSH_VERSION=$(zsh --version | cut -d' ' -f2 || :)
ZSH_VERSION_LATEST=$(dlast -r zshusers zsh)
printf "├── %-15s %10s " "Zsh" "v${ZSH_VERSION}"
[[ "${ZSH_VERSION_LATEST}" == "${ZSH_VERSION}" ]] && echo "✅" || echo "🆕 new version available v${ZSH_VERSION_LATEST}"

GO_VERSION=$(go version | cut -d' ' -f3 || :)
printf "├── %-15s %10s " "Go" "v${GO_VERSION#go}"
LATEST_GO_VERSION=$(dlast golang)
[[ "${LATEST_GO_VERSION}" == "${GO_VERSION#go}" ]] && echo "✅" || echo "🆕 new golang version available v${LATEST_GO_VERSION}, run 'goup' to update"

echo
echo "Development tools"
# VSCode Go Extension requirements (https://github.com/golang/vscode-go/blob/master/docs/tools.md)
print_version "Gopls" "golang" "tools" "$(get_gopls_version)" "gopls"
print_version "Delve" "go-delve" "delve" "$(get_delve_version)"
print_version "Gopkgs" "uudashr" "gopkgs" "$(get_gopkgs_version)"
print_version "Goplay" "haya14busa" "goplay" "$(get_goplay_version)"
print_version "Gomodifytags" "fatih" "gomodifytags" "$(get_gomodifytags_version)"
# Linters
print_version "GolangCI Lint" "golangci" "golangci-lint" "$(get_golangci_lint_version)"
# Test helpers
print_version "Venom" "ovh" "venom" "$(get_venom_version)"
# Documentation helpers
print_version "Changie" "miniscruff" "changie" "$(get_changie_version)"
# Build helpers
print_version "Github CLI" "cli" "cli" "$(get_githubcli_version)"
print_version "Neon" "c4s4" "neon" "$(get_neon_version)"
print_version "GoReleaser" "goreleaser" "goreleaser" "$(get_goreleaser_version)"
print_version "SVU" "caarlos0" "svu" "$(get_svu_version)"
echo
