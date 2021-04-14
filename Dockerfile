ARG ALPINE_VERSION=3.13

FROM alpine:${ALPINE_VERSION}

# Timezones
RUN apk add -q --update --progress --no-cache tzdata
ENV TZ=

# Docker
RUN apk add -q --update --progress --no-cache docker-cli docker-compose

# GO
RUN apk add -q --update --progress --no-cache go
ENV CGO_ENABLED=0 \
    GO111MODULE=on

# Git
RUN apk add -q --update --progress --no-cache git

# Zsh
RUN apk add -q --update --progress --no-cache zsh
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TERM xterm

# Zsh Theme
RUN wget -O- -nv https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh \
 && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k \
 && rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k/.git*
ENV ZSH /root/.oh-my-zsh

# Zsh Theme configuration
COPY .zshrc /root/.zshrc
COPY .p10k.zsh /root/.p10k.zsh

WORKDIR /root
ENTRYPOINT [ "/bin/zsh" ]
