#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

case $1 in

  "cli")
    GITHUBCLI_VERSION="$2"
    wget -O- -nv https://github.com/cli/cli/releases/download/v${GITHUBCLI_VERSION}/gh_${GITHUBCLI_VERSION}_linux_amd64.tar.gz | tar -xzO gh_${GITHUBCLI_VERSION}_linux_amd64/bin/gh > /usr/local/bin/gh
    chmod +x /usr/local/bin/gh
    ;;

  "neon")
    NEON_VERSION="$2"
    (
      cd ~
      git clone --depth 1 --branch $NEON_VERSION https://github.com/c4s4/neon.git
      cd neon/neon
      go install -ldflags "-X github.com/c4s4/neon/neon/build.NeonVersion=$NEON_VERSION"
      rm -rf ~/neon
    )
    ;;

  "golangci-lint")
    GOLANGCI_LINT_VERSION="$2"
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v$GOLANGCI_LINT_VERSION
    ;;

  "goreleaser")
    GORELEASER_VERSION="$2"
    wget -O- -nv https://install.goreleaser.com/github.com/goreleaser/goreleaser.sh | sh -s -- -b /usr/local/bin v${GORELEASER_VERSION}
    ;;

  "svu")
    SVU_VERSION="$2"
    wget -O- -nv https://install.goreleaser.com/github.com/caarlos0/svu.sh | sh -s -- -b /usr/local/bin v${SVU_VERSION}
    ;;

  "venom")
    VENOM_VERSION="$2"
    wget -O /usr/local/bin/venom -nv https://github.com/ovh/venom/releases/download/v${VENOM_VERSION}/venom.linux-amd64
    chmod +x /usr/local/bin/venom
    ;;

  "gopls")
    GOPLS_VERSION="$2"
    go install golang.org/x/tools/gopls@v${GOPLS_VERSION}
    ;;

  "delve")
    DELVE_VERSION="$2"
    go install github.com/go-delve/delve/cmd/dlv@v${DELVE_VERSION}
    ;;

  *)
    echo "Unknown tool : $1"
    ;;
esac
