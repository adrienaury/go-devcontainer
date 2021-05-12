ARG ALPINE_VERSION=3.13
ARG GO_VERSION=1.16.4
ARG DOCKER_VERSION=20.10.6
ARG DOCKER_COMPOSE_VERSION=1.29.2

FROM docker:${DOCKER_VERSION} AS docker
FROM docker/compose:alpine-${DOCKER_COMPOSE_VERSION} AS docker-compose
FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS go

####################################################################################
## go-devcontainer-alpine-ci stage                                                ##
##   contains minimal setup to run on a CI platform                               ##
####################################################################################

FROM alpine:${ALPINE_VERSION} AS go-devcontainer-alpine-ci

# Required packages for CI
RUN apk add -q --update --progress --no-cache \
    ca-certificates \
    wget curl \
    bash zsh \
    git

# Go
COPY --from=go /usr/local/go /usr/local/go

COPY scripts/cache-command.sh /usr/local/bin/cache
COPY scripts/install-tool.sh /usr/local/bin/up

RUN addgroup -g 1000 -S vscode \
    && adduser -S -s /bin/zsh -G vscode -D -u 1000 vscode \
    && cp -r /root/. /home/vscode \
    && chown -R vscode:vscode /home/vscode

USER vscode

ENV GOPATH="/home/vscode/go"
ENV GOBIN="${GOPATH}/bin"
ENV PATH="${PATH}:/usr/local/go/bin:${GOPATH}/bin" \
    CGO_ENABLED=0 \
    GO111MODULE=on

RUN    up golangci-lint 1.40.0 \
    && up venom         1.0.0-rc.4 \
    && up neon          1.5.3 \
    && up goreleaser    0.164.0 \
    && up svu           1.3.2 \
    && go clean -cache -testcache

####################################################################################
## go-devcontainer-alpine-slim stage                                              ##
##   contains a slim setup for development usage                                  ##
####################################################################################

FROM go-devcontainer-alpine-ci AS go-devcontainer-alpine-slim

USER root

# Timezones
RUN apk add -q --update --progress --no-cache \
    tzdata \
    su-exec sudo \
    git-perl \
    figlet \
    jq \
    # Promote user as sudoer
    && echo vscode ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode

# Default values, override with a dotfile repository (https://code.visualstudio.com/docs/remote/containers#_personalizing-with-dotfile-repositories)
ENV TZ= \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    TERM=xterm

# Zsh Theme
RUN wget -O- -nv https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh \
    && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k \
    && rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k/.git* \
    && mkdir -p /root/.cache/gitstatus \
    && wget -O- -nv https://github.com/romkatv/gitstatus/releases/download/v1.3.1/gitstatusd-linux-x86_64.tar.gz | tar -xz -C /root/.cache/gitstatus gitstatusd-linux-x86_64

# Zsh Theme configuration
COPY .zshrc /root/.zshrc
COPY .p10k.zsh /root/.p10k.zsh

# Docker CLI and docker-compose
COPY --from=docker /usr/local/bin/docker /usr/bin/docker
COPY --from=docker-compose /usr/local/bin/docker-compose /usr/bin/docker-compose

COPY welcome.sh /root/welcome.sh
COPY scripts/list-docker-tags.sh /usr/local/bin/dtags
COPY scripts/get-latest-version-docker.sh /usr/local/bin/dlast
COPY scripts/get-latest-version-github.sh /usr/local/bin/glast
COPY scripts/update-go.sh /usr/local/bin/up-go
COPY scripts/update-docker.sh /usr/local/bin/up-docker
COPY scripts/update-docker-compose.sh /usr/local/bin/up-docker-compose
COPY scripts/update-git.sh /usr/local/bin/up-git

ENTRYPOINT [ "/bin/zsh" ]

####################################################################################
## go-devcontainer-alpine stage                                                   ##
##   contains a full setup for development usage                                  ##
####################################################################################

FROM go-devcontainer-alpine-slim AS go-devcontainer-alpine

# These tools are usually installed by VSCode golang extension
RUN    up gopls         0.6.11 \
    && up delve         1.6.0 \
    && up gopkgs        2.1.2 \
    && up go-outline \
    && up goplay        1.0.0 \
    && up gomodifytags  1.13.0 \
    && up impl \
    && up gotests       1.6.0 \
    && go clean -cache -testcache

# Optionnal tools
RUN    up changie    0.5.0 \
    && up cli        1.9.2 \
    && go clean -cache -testcache
