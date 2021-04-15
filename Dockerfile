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
RUN wget -O- -nv https://install.goreleaser.com/github.com/goreleaser/goreleaser.sh | sh -s -- -b /usr/local/bin

# svu
RUN wget -O- -nv https://install.goreleaser.com/github.com/caarlos0/svu.sh | sh -s -- -b /usr/local/bin

WORKDIR /root
ENTRYPOINT [ "/bin/zsh" ]
