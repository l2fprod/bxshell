FROM ubuntu:16.04
RUN apt-get -qq update
RUN apt-get -qq install -y \
  apt-transport-https \
  bash-completion \
  ca-certificates \
  curl \
  figlet \
  inetutils-ping \
  jq \
  nano \
  software-properties-common \
  sudo \
  wget

# Docker in Docker
RUN apt-get -qq remove docker docker-engine docker.io
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get -qq update
RUN apt-get -qq -y install docker-ce

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# NVM for Node.JS
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash
RUN bash -c 'source /root/.nvm/nvm.sh; nvm install node; nvm cache clear'

# Bluemix CLI
RUN curl -fsSL https://clis.ng.bluemix.net/install/linux > /tmp/bxinstall.sh
RUN sh /tmp/bxinstall.sh

# Bluemix CLI plugins
RUN bx plugin install cloud-functions -f -r Bluemix
RUN bx plugin install container-registry -f -r Bluemix
RUN bx plugin install container-service -f -r Bluemix
RUN bx plugin install dev -f -r Bluemix
RUN bx plugin install schematics -f -r Bluemix

# Kubernetes
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN mv kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

# Istio
RUN (cd /usr/local && curl -L https://git.io/getIstio | sh - )
RUN ln -s /usr/local/istio* /usr/local/istio

# Helm
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# Expose configuration to be overriden
RUN mkdir -p /root/mnt/config

# Bluemix CLI configuration
RUN rm /root/.bluemix/config.json
RUN touch /root/mnt/config/bx-config.json
RUN ln -s /root/mnt/config/bx-config.json /root/.bluemix/config.json

# Bluemix CF configuration
RUN rm /root/.bluemix/.cf/config.json
RUN touch /root/mnt/config/cf-config.json
RUN ln -s /root/mnt/config/cf-config.json /root/.bluemix/.cf/config.json

# Bluemix container-registry
RUN mkdir /root/mnt/config/container-registry
RUN ln -s /root/mnt/config/container-registry/config.json /root/.bluemix/plugins/container-registry/config.json

# Bluemix container-service
RUN mkdir /root/mnt/config/container-service
RUN ln -s /root/mnt/config/container-service/config.json /root/.bluemix/plugins/container-service/config.json
RUN ln -s /root/mnt/config/container-service/clusters /root/.bluemix/plugins/container-service/clusters

# Bluemix SoftLayer service
RUN mkdir /root/mnt/config/softlayer
RUN ln -s /root/mnt/config/softlayer /root/.bluemix/plugins/softlayer

# Helm configuration
RUN mkdir /root/mnt/config/helm
RUN ln -s /root/mnt/config/helm /root/.helm

# Docker configuration
RUN mkdir /root/mnt/config/docker
RUN ln -s /root/mnt/config/docker /root/.docker

VOLUME /root/mnt/config

# User files
VOLUME /root/mnt/home

COPY .bash_profile /root
COPY .motd.txt /root
ENV TERM xterm-256color

WORKDIR "/root"
ENTRYPOINT [ "bash", "-l" ]
