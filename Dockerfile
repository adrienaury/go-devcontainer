ARG ALPINE_VERSION=3.13
ARG GO_VERSION=1.16.3
FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS go
FROM alpine:${ALPINE_VERSION}

# Timezones
RUN apk add -q --update --progress --no-cache tzdata
ENV TZ=

# Git
RUN apk add -q --update --progress --no-cache git git-perl

# Zsh
RUN apk add -q --update --progress --no-cache zsh
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    TERM=xterm

# Zsh Theme
RUN wget -O- -nv https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh \
 && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k \
 && rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k/.git*
 && wget -O- -nv https://github.com/romkatv/gitstatus/releases/download/v1.3.1/gitstatusd-linux-x86_64.tar.gz | tar -xz -C /root/.cache/gitstatus gitstatusd-linux-x86_64
ENV ZSH /root/.oh-my-zsh

# Zsh Theme configuration
COPY .zshrc /root/.zshrc
COPY .p10k.zsh /root/.p10k.zsh

# Go
COPY --from=go /usr/local/go /usr/local/go
ENV GOPATH=/root/go
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin \
    CGO_ENABLED=0 \
    GO111MODULE=on

# Docker CLI
RUN apk add -q --update --progress --no-cache docker-cli docker-compose

# Other utilities
RUN apk add -q --update --progress --no-cache jq bash curl figlet

# Github CLI
ARG GITHUBCLI_VERSION=1.9.1
ENV GITHUBCLI_VERSION=$GITHUBCLI_VERSION
RUN wget -O- -nv https://github.com/cli/cli/releases/download/v${GITHUBCLI_VERSION}/gh_${GITHUBCLI_VERSION}_linux_amd64.tar.gz | tar -xzO gh_${GITHUBCLI_VERSION}_linux_amd64/bin/gh > /usr/local/bin/gh \
 && chmod +x /usr/local/bin/gh

# Neon
ARG NEON_VERSION=1.5.3
ENV NEON_VERSION=$NEON_VERSION
RUN git clone --depth 1 --branch $NEON_VERSION https://github.com/c4s4/neon.git \
 && (cd neon/neon && go install -ldflags "-X github.com/c4s4/neon/neon/build.NeonVersion=$NEON_VERSION") \
 && rm -rf neon

# GolangCI Lint
ARG GOLANGCI_LINT_VERSION=1.39.0
ENV GOLANGCI_LINT_VERSION=$GOLANGCI_LINT_VERSION
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v$GOLANGCI_LINT_VERSION

# GoReleaser
ARG GORELEASER_VERSION=0.162.1
ENV GORELEASER_VERSION=$GORELEASER_VERSION
RUN wget -O- -nv https://install.goreleaser.com/github.com/goreleaser/goreleaser.sh | sh -s -- -b /usr/local/bin v${GORELEASER_VERSION}

# SVU
ARG SVU_VERSION=1.3.2
ENV SVU_VERSION=$SVU_VERSION
RUN wget -O- -nv https://install.goreleaser.com/github.com/caarlos0/svu.sh | sh -s -- -b /usr/local/bin v${SVU_VERSION}

# Venom
ARG VENOM_VERSION=1.0.0-rc.4
ENV VENOM_VERSION=$VENOM_VERSION
RUN wget -O /usr/local/bin/venom -nv https://github.com/ovh/venom/releases/download/v${VENOM_VERSION}/venom.linux-amd64 \
 && chmod +x /usr/local/bin/venom

# Gopls
ARG GOPLS_VERSION=0.6.10
ENV GOPLS_VERSION=$GOPLS_VERSION
RUN go install golang.org/x/tools/gopls@v${GOPLS_VERSION}

# Delve
ARG DELVE_VERSION=1.6.0
ENV DELVE_VERSION=$DELVE_VERSION
RUN go install github.com/go-delve/delve/cmd/dlv@v${DELVE_VERSION}

# Changie
ARG CHANGIE_VERSION=0.4.1
RUN wget -O- -nv https://github.com/miniscruff/changie/releases/download/v${CHANGIE_VERSION}/changie_${CHANGIE_VERSION}_linux_amd64.tar.gz | tar -xzO changie > /usr/local/bin/changie \
 && chmod +x /usr/local/bin/changie

COPY welcome.sh /root/welcome.sh
COPY scripts /root/scripts

COPY scripts/cache-command.sh /usr/local/bin/cache
COPY scripts/list-docker-tags.sh /usr/local/bin/dtags
COPY scripts/install-tool.sh /usr/local/bin/instool
COPY scripts/get-latest-version-docker.sh /usr/local/bin/dlast
COPY scripts/get-latest-version-github.sh /usr/local/bin/glast

WORKDIR /root
ENTRYPOINT [ "/bin/zsh" ]
