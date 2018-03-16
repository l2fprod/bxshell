FROM l2fprod/bxshell-base:latest

COPY install.sh install.sh
RUN ./install.sh && rm install.sh

# Environment configuration
VOLUME /root/mnt/config

# User files
VOLUME /root/mnt/home

COPY .bash_profile /root
COPY .motd.txt /root
ENV TERM xterm-256color

WORKDIR "/root"
ENTRYPOINT [ "bash", "-l" ]
