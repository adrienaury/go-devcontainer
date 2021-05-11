#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

case $1 in

  "cli")
    GITHUBCLI_VERSION="$2"
    wget -O- -nv https://github.com/cli/cli/releases/download/v${GITHUBCLI_VERSION}/gh_${GITHUBCLI_VERSION}_linux_amd64.tar.gz | tar -xzO gh_${GITHUBCLI_VERSION}_linux_amd64/bin/gh > ${GOBIN}/gh
    chmod +x ${GOBIN}/gh
    ;;

  "neon")
    NEON_VERSION="$2"
    cd ~
    git clone --depth 1 --branch $NEON_VERSION https://github.com/c4s4/neon.git
    cd neon/neon
    go install -ldflags "-X github.com/c4s4/neon/neon/build.NeonVersion=$NEON_VERSION"
    rm -rf ~/neon
    ;;

  "golangci-lint")
    GOLANGCI_LINT_VERSION="$2"
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v${GOLANGCI_LINT_VERSION}
    ;;

  "goreleaser")
    GORELEASER_VERSION="$2"
    go install github.com/goreleaser/goreleaser@v${GORELEASER_VERSION}
    ;;

  "svu")
    SVU_VERSION="$2"
    wget -O- -nv https://install.goreleaser.com/github.com/caarlos0/svu.sh | sh -s -- -b  ${GOBIN} v${SVU_VERSION}
    ;;

  "venom")
    VENOM_VERSION="$2"
    wget -O ${GOBIN}/venom -nv https://github.com/ovh/venom/releases/download/v${VENOM_VERSION}/venom.linux-amd64
    chmod +x  ${GOBIN}/venom
    ;;

  "gopls")
    GOPLS_VERSION="$2"
    go install golang.org/x/tools/gopls@v${GOPLS_VERSION}
    ;;

  "delve")
    DELVE_VERSION="$2"
    go install github.com/go-delve/delve/cmd/dlv@v${DELVE_VERSION}
    ;;

  "changie")
    CHANGIE_VERSION="$2"
    go install github.com/miniscruff/changie@v${CHANGIE_VERSION}
    ;;

  "gopkgs")
    GOPKGS_VERSION="$2"
    go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@v${GOPKGS_VERSION}
    echo ${GOPKGS_VERSION} > ~/.gopkgs
    ;;

  "go-outline")
    go install github.com/ramya-rao-a/go-outline@latest
    ;;

  "goplay")
    GOPLAY_VERSION="$2"
    go install github.com/haya14busa/goplay/cmd/goplay@v${GOPLAY_VERSION}
    echo ${GOPLAY_VERSION} > ~/.goplay
    ;;

  "gomodifytags")
    GOMODIFYTAGS_VERSION="$2"
    go install github.com/fatih/gomodifytags@v${GOMODIFYTAGS_VERSION}
    echo ${GOMODIFYTAGS_VERSION} > ~/.gomodifytags
    ;;

  "impl")
    go install github.com/josharian/impl@latest
    ;;

  "gotests")
    GOTESTS_VERSION="$2"
    go install github.com/cweill/gotests/gotests@v${GOTESTS_VERSION}
    echo ${GOTESTS_VERSION} > ~/.gotests
    ;;

  *)
    echo "Unknown tool : $1"
    ;;
esac

# invalidate cache for welcome page
cache -d -- bash ~/welcome.sh
