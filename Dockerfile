FROM ubuntu:24.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        openssh-server vim tmux zsh git curl ca-certificates gnupg && \
    mkdir /var/run/sshd

# install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# install Claude CLI
RUN npm install -g @anthropic-ai/claude-code

# prepare root ssh folder
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# make zsh default shell
RUN chsh -s /usr/bin/zsh root

RUN apt-get install -y locales && \
    locale-gen ru_RU.UTF-8 && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=ru_RU.UTF-8 LANGUAGE=ru_RU:ru LC_ALL=ru_RU.UTF-8

RUN echo "export LANG=ru_RU.UTF-8" >> /etc/zsh/zshenv && \
    echo "export LANGUAGE=ru_RU:ru" >> /etc/zsh/zshenv && \
    echo "export LC_ALL=ru_RU.UTF-8" >> /etc/zsh/zshenv

RUN npm install -g likec4

EXPOSE 22 5173

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e"]
