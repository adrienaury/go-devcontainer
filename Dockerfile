ARG ALPINE_VERSION=3.13

FROM alpine:${ALPINE_VERSION}

# Timezones
RUN apk add -q --update --progress --no-cache tzdata
ENV TZ=

# Git
RUN apk add -q --update --progress --no-cache git

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
ENV ZSH /root/.oh-my-zsh

# Zsh Theme configuration
COPY .zshrc /root/.zshrc
COPY .p10k.zsh /root/.p10k.zsh

# Go
RUN apk add -q --update --progress --no-cache go
ENV CGO_ENABLED=0 \
    GO111MODULE=on \
    PATH=$PATH:/root/go/bin

# Docker CLI
RUN apk add -q --update --progress --no-cache docker-cli docker-compose

# Github CLI
ARG GITHUBCLI_VERSION=1.9.1
ENV GITHUBCLI_VERSION=$GITHUBCLI_VERSION
RUN wget -O- -nv https://github.com/cli/cli/releases/download/v${GITHUBCLI_VERSION}/gh_${GITHUBCLI_VERSION}_linux_amd64.tar.gz | tar -xzO gh_${GITHUBCLI_VERSION}_linux_amd64/bin/gh > /usr/local/bin/gh \
 && chmod +x /usr/local/bin/gh

# Neon
ARG NEON_VERSION=1.4.4
ENV NEON_VERSION=$NEON_VERSION
RUN git clone --depth 1 --branch $NEON_VERSION https://github.com/c4s4/neon.git \
 && (cd neon/neon && go install -ldflags "-X github.com/c4s4/neon/neon/build.NeonVersion=$NEON_VERSION")

# GolangCI
ARG GOLANGCI_VERSION=1.39.0
ENV GOLANGCI_VERSION=$GOLANGCI_VERSION
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v$GOLANGCI_VERSION

# GoReleaser
ARG GORELEASER_VERSION=0.162.0
ENV GORELEASER_VERSION=$GORELEASER_VERSION
RUN wget -O- -nv https://install.goreleaser.com/github.com/goreleaser/goreleaser.sh | sh -s -- -b /usr/local/bin v${GORELEASER_VERSION}

# svu
ARG SVU_VERSION=1.3.2
ENV SVU_VERSION=$SVU_VERSION
RUN wget -O- -nv https://install.goreleaser.com/github.com/caarlos0/svu.sh | sh -s -- -b /usr/local/bin v${SVU_VERSION}

WORKDIR /root
ENTRYPOINT [ "/bin/zsh" ]
