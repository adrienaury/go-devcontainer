ARG ALPINE_VERSION=3.13
ARG GO_VERSION=1.16.3
ARG DOCKER_VERSION=20.10.6
FROM docker:${DOCKER_VERSION} AS docker
FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS go
FROM alpine:${ALPINE_VERSION} AS go-devcontainer-light

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
 && rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k/.git* \
 && mkdir -p /root/.cache/gitstatus \
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
COPY --from=docker /usr/local/bin/docker /usr/bin/docker

# Other utilities
RUN apk add -q --update --progress --no-cache jq bash curl figlet

COPY welcome.sh /root/welcome.sh
COPY scripts/cache-command.sh /usr/local/bin/cache
COPY scripts/list-docker-tags.sh /usr/local/bin/dtags
COPY scripts/install-tool.sh /usr/local/bin/instool
COPY scripts/get-latest-version-docker.sh /usr/local/bin/dlast
COPY scripts/get-latest-version-github.sh /usr/local/bin/glast
COPY scripts/go-updater.sh /usr/local/bin/goup
COPY scripts/docker-updater.sh /usr/local/bin/doup

# Install required development tools
RUN instool gopls 0.6.10 \
 && instool delve 1.6.0

ENTRYPOINT [ "/bin/zsh" ]

FROM go-devcontainer-light AS go-devcontainer

# Install all optional development tools
RUN instool golangci-lint 1.39.0 \
 && instool venom         1.0.0-rc.4 \
 && instool changie       0.4.1 \
 && instool cli           1.9.2 \
 && instool neon          1.5.3 \
 && instool goreleaser    0.164.0 \
 && instool svu           1.3.2
