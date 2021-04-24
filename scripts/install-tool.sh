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
    if [[ "${USER-n/a}" == "root" && "${SUDO_USER-n/a}" != "n/a" ]]; then
      su-exec ${SUDO_USER} bash << EOF
      cd ~
      git clone --depth 1 --branch $NEON_VERSION https://github.com/c4s4/neon.git
      cd neon/neon
      go install -ldflags "-X github.com/c4s4/neon/neon/build.NeonVersion=$NEON_VERSION"
      rm -rf ~/neon
EOF
    else
    (
      cd ~
      git clone --depth 1 --branch $NEON_VERSION https://github.com/c4s4/neon.git
      cd neon/neon
      go install -ldflags "-X github.com/c4s4/neon/neon/build.NeonVersion=$NEON_VERSION"
      rm -rf ~/neon
    )
    fi
    ;;

  "golangci-lint")
    GOLANGCI_LINT_VERSION="$2"
    if [[ "${USER-n/a}" == "root" && "${SUDO_USER-n/a}" != "n/a" ]]; then
      su-exec ${SUDO_USER} bash << EOF
      curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v$GOLANGCI_LINT_VERSION
EOF
    else
    (
      curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v$GOLANGCI_LINT_VERSION
    )
    fi
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
    if [[ "${USER-n/a}" == "root" && "${SUDO_USER-n/a}" != "n/a" ]]; then
      su-exec ${SUDO_USER} bash << EOF
      go install golang.org/x/tools/gopls@v${GOPLS_VERSION}
EOF
    else
    (
      go install golang.org/x/tools/gopls@v${GOPLS_VERSION}
    )
    fi
    ;;

  "delve")
    DELVE_VERSION="$2"
    if [[ "${USER-n/a}" == "root" && "${SUDO_USER-n/a}" != "n/a" ]]; then
      su-exec ${SUDO_USER} bash << EOF
      go install github.com/go-delve/delve/cmd/dlv@v${DELVE_VERSION}
EOF
    else
    (
      go install github.com/go-delve/delve/cmd/dlv@v${DELVE_VERSION}
    )
    fi
    ;;

  "changie")
    CHANGIE_VERSION="$2"
    wget -O- -nv https://github.com/miniscruff/changie/releases/download/v${CHANGIE_VERSION}/changie_${CHANGIE_VERSION}_linux_amd64.tar.gz | tar -xzO changie > /usr/local/bin/changie
    chmod +x /usr/local/bin/changie
    ;;

  "gopkgs")
    GOPKGS_VERSION="$2"
    if [[ "${USER-n/a}" == "root" && "${SUDO_USER-n/a}" != "n/a" ]]; then
      su-exec ${SUDO_USER} bash << EOF
      go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@v${GOPKGS_VERSION}
      echo ${GOPKGS_VERSION} > ~/.gopkgs
EOF
    else
    (
      go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@v${GOPKGS_VERSION}
      echo ${GOPKGS_VERSION} > ~/.gopkgs
    )
    fi
    ;;

  "go-outline")
    if [[ "${USER-n/a}" == "root" && "${SUDO_USER-n/a}" != "n/a" ]]; then
      su-exec ${SUDO_USER} bash << EOF
      go get -u github.com/ramya-rao-a/go-outline
EOF
    else
    (
      go get -u github.com/ramya-rao-a/go-outline
    )
    fi
    ;;

  "goplay")
    GOPLAY_VERSION="$2"
    if [[ "${USER-n/a}" == "root" && "${SUDO_USER-n/a}" != "n/a" ]]; then
      su-exec ${SUDO_USER} bash << EOF
      go install github.com/haya14busa/goplay/cmd/goplay@v${GOPLAY_VERSION}
      echo ${GOPLAY_VERSION} > ~/.goplay
EOF
    else
    (
      go install github.com/haya14busa/goplay/cmd/goplay@v${GOPLAY_VERSION}
      echo ${GOPLAY_VERSION} > ~/.goplay
    )
    fi
    ;;

  "gomodifytags")
    GOMODIFYTAGS_VERSION="$2"
    if [[ "${USER-n/a}" == "root" && "${SUDO_USER-n/a}" != "n/a" ]]; then
      su-exec ${SUDO_USER} bash << EOF
      go install github.com/fatih/gomodifytags@v${GOMODIFYTAGS_VERSION}
      echo ${GOMODIFYTAGS_VERSION} > ~/.gomodifytags
EOF
    else
    (
      go install github.com/fatih/gomodifytags@v${GOMODIFYTAGS_VERSION}
      echo ${GOMODIFYTAGS_VERSION} > ~/.gomodifytags
    )
    fi
    ;;

  "impl")
    if [[ "${USER-n/a}" == "root" && "${SUDO_USER-n/a}" != "n/a" ]]; then
      su-exec ${SUDO_USER} bash << EOF
      go get -u github.com/josharian/impl
EOF
    else
    (
      go get -u github.com/josharian/impl
    )
    fi
    ;;

  "gotests")
    GOTESTS_VERSION="$2"
    if [[ "${USER-n/a}" == "root" && "${SUDO_USER-n/a}" != "n/a" ]]; then
      su-exec ${SUDO_USER} bash << EOF
      go install github.com/cweill/gotests/gotests@v${GOTESTS_VERSION}
      echo ${GOTESTS_VERSION} > ~/.gotests
EOF
    else
    (
      go install github.com/cweill/gotests/gotests@v${GOTESTS_VERSION}
      echo ${GOTESTS_VERSION} > ~/.gotests
    )
    fi
    ;;

  *)
    echo "Unknown tool : $1"
    ;;
esac
