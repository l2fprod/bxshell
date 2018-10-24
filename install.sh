#!/bin/bash
set -e
export SHELLOPTS

# NVM for Node.JS
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash
source /root/.nvm/nvm.sh
nvm install 6.9.1
npm install -g nodemon

# Serverless
npm install -g serverless serverless-openwhisk@latest --unsafe-perm spawn-sync
serverless slstats -d
npm install -g @ibm-functions/shell --unsafe-perm

# wskdeploy
curl -LO $(curl --retry 10 --retry-delay 5 --silent "https://api.github.com/repos/apache/incubator-openwhisk-wskdeploy/releases/latest" | jq -r .assets[].browser_download_url | grep linux-amd64) \
  && tar zxvf openwhisk_wskdeploy*.tgz wskdeploy \
  && mv wskdeploy /usr/local/bin/ \
  && rm -f openwhisk_wskdeploy*.tgz

# SoftLayer
pip install softlayer

# Bluemix CLI
echo ">> ibmcloud"
curl -fsSL https://clis.ng.bluemix.net/install/linux > /tmp/bxinstall.sh
sh /tmp/bxinstall.sh
rm /tmp/bxinstall.sh

# Bluemix CLI plugins
echo ">> ibmcloud plugins"
bx plugin install activity-tracker -f -r Bluemix
bx plugin install cloud-functions -f -r Bluemix
bx plugin install cloud-internet-services -r Bluemix
bx plugin install container-registry -f -r Bluemix
bx plugin install container-service -f -r Bluemix
bx plugin install dev -f -r Bluemix
bx plugin install infrastructure-service -r Bluemix
bx plugin install logging-cli -r Bluemix

# Kubernetes
echo ">> kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl --retry 10 --retry-delay 5 -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && mv kubectl /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl

# Kubetail
echo ">> kubetail"
curl -LO https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail \
  && mv kubetail /usr/local/bin/kubetail \
  && chmod +x /usr/local/bin/kubetail

# Kail https://github.com/boz/kail
echo ">> kail"
curl -LO $(curl --retry 10 --retry-delay 5 --silent "https://api.github.com/repos/boz/kail/releases/latest" | jq -r .assets[].browser_download_url | grep linux_amd64) \
  && mkdir kail \
  && tar zxvf kail*linux*.tar.gz -C kail \
  && mv kail/kail /usr/local/bin/kail \
  && rm -rf kail kail*linux*.tar.gz

# Istio
echo ">> istio"
curl -LO $(curl --retry 10 --retry-delay 5 --silent "https://api.github.com/repos/istio/istio/releases/latest" | jq -r .assets[].browser_download_url | grep linux) \
  && tar zxvf istio-*.tar.gz \
  && rm -f istio-*.tar.gz \
  && mv istio-* /usr/local/ \
  && ln -s /usr/local/istio* /usr/local/istio

# Knative CLI https://github.com/cppforlife/knctl
echo ">> knctl"
curl -LO $(curl --retry 10 --retry-delay 5 --silent "https://api.github.com/repos/cppforlife/knctl/releases/latest" | jq -r .assets[].browser_download_url | grep linux-amd64) \
  && mv knctl* /usr/local/bin/knctl \
  && chmod +x /usr/local/bin/knctl

# Helm
echo ">> helm"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# IBM provider for Terraform
echo ">> terraform"
curl -LO $(curl --retry 10 --retry-delay 5 -I https://github.com/IBM-Cloud/terraform-provider-ibm/releases/latest | grep Location | awk '{print $2}' | sed 's/tag/download/g' | tr -d '[:space:]')/linux_amd64.zip && \
  unzip linux_amd64.zip && \
  rm -f linux_amd64.zip && \
  mkdir /usr/local/share/terraform && \
  mv terraform-provider-ibm* /usr/local/share/terraform/terraform-provider-ibm && \
  echo 'providers {
  ibm = "/usr/local/share/terraform/terraform-provider-ibm"
}' > /root/.terraformrc

# Expose configuration to be overriden
mkdir -p /root/mnt/config

# Bluemix CLI configuration
rm /root/.bluemix/config.json
touch /root/mnt/config/bx-config.json
ln -s /root/mnt/config/bx-config.json /root/.bluemix/config.json

# Bluemix CF configuration
rm /root/.bluemix/.cf/config.json
touch /root/mnt/config/cf-config.json
ln -s /root/mnt/config/cf-config.json /root/.bluemix/.cf/config.json

# Bluemix Cloud Functions configuration
touch /root/mnt/config/wsk.props
ln -s /root/mnt/config/wsk.props /root/.wskprops

# Bluemix container-registry
mkdir /root/mnt/config/container-registry
ln -s /root/mnt/config/container-registry/config.json /root/.bluemix/plugins/container-registry/config.json

# Bluemix container-service
mkdir /root/mnt/config/container-service
ln -s /root/mnt/config/container-service/config.json /root/.bluemix/plugins/container-service/config.json
ln -s /root/mnt/config/container-service/clusters /root/.bluemix/plugins/container-service/clusters

# SoftLayer CLI
touch /root/mnt/config/slcli.conf
ln -s /root/mnt/config/slcli.conf /root/.softlayer

# Bluemix SoftLayer service
mkdir /root/mnt/config/softlayer
ln -s /root/mnt/config/softlayer /root/.bluemix/plugins/softlayer

# Helm configuration
mkdir /root/mnt/config/helm
ln -s /root/mnt/config/helm /root/.helm

# Docker configuration
mkdir /root/mnt/config/docker
ln -s /root/mnt/config/docker /root/.docker

# Clean up
nvm cache clear
