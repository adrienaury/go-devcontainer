ARG ALPINE_VERSION=3.13

FROM alpine:${ALPINE_VERSION}

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

# Zsh Theme
RUN wget -O- -nv https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh \
 && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k \
 && rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k/.git* \
 && echo "export LANG='en_US.UTF-8'" > ~/.zshrc \
 && echo "export LC_ALL='en_US.UTF-8'" >> ~/.zshrc \
 && echo "export LANGUAGE='en_US:en'" >> ~/.zshrc \
 && echo "export TERM=xterm" >> ~/.zshrc \
 && echo "export ZSH='/root/.oh-my-zsh'" >> ~/.zshrc \
 && echo "ZSH_THEME='powerlevel10k/powerlevel10k'" >> ~/.zshrc \
 && echo "plugins=(git)" >> ~/.zshrc \
 && echo 'POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"' >> ~/.zshrc \
 && echo 'POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir vcs status)' >> ~/.zshrc \
 && echo 'POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()' >> ~/.zshrc \
 && echo 'POWERLEVEL9K_STATUS_OK=false' >> ~/.zshrc \
 && echo 'POWERLEVEL9K_STATUS_CROSS=true' >> ~/.zshrc \
 && echo 'source $ZSH/oh-my-zsh.sh' >> ~/.zshrc
ENV ZSH="~/.oh-my-zsh"

WORKDIR /root
ENTRYPOINT [ "/bin/zsh" ]
