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

### Miscellaneous development tools ###

# Docker CLI
RUN apk add -q --update --progress --no-cache docker-cli docker-compose

### Go developement tools ###
ARG GOLANGCI_VERSION=v1.39.0

# Go
RUN apk add -q --update --progress --no-cache go
ENV CGO_ENABLED=0 \
    GO111MODULE=on

# Linters
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin $GOLANGCI_VERSION

WORKDIR /root
ENTRYPOINT [ "/bin/zsh" ]
