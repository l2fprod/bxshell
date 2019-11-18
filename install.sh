#!/bin/bash
set -e
export SHELLOPTS

function get_latest {
  latest_content=$(curl -H "Authorization: token $GITHUB_TOKEN" --silent "https://api.github.com/repos/$1/releases/latest")
  latest_url=$(echo $latest_content | jq -r '.assets[] | select(.browser_download_url | test("'$2'")) | .browser_download_url')
  if [ ! -z "$latest_url" ]; then
    echo $latest_url
  else
    echo "Failed to get $1: $latest_content"
    exit 2
  fi
}

# NVM for Node.JS
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash
source /root/.nvm/nvm.sh
nvm install 12
nvm install 6.9.1
npm install -g nodemon

# Serverless
echo ">> serverless"
npm install -g serverless serverless-openwhisk@latest --unsafe-perm spawn-sync

# SoftLayer
echo ">> softlayer"
pip install softlayer

# IBM Cloud CLI
echo ">> ibmcloud"
curl -fsSL https://clis.ng.bluemix.net/install/linux > /tmp/bxinstall.sh
sh /tmp/bxinstall.sh
rm /tmp/bxinstall.sh

# IBM Cloud CLI plugins
echo ">> ibmcloud plugins"
ibmcloud_plugins=( \
  cloud-databases \
  cloud-functions \
  cloud-internet-services \
  cloud-object-storage \
  container-registry \
  container-service \
  dev \
  vpc-infrastructure \
  key-protect \
  power-iaas \
  schematics \
)
for plugin in "${ibmcloud_plugins[@]}"
do
  ibmcloud plugin install $plugin -f -r "IBM Cloud"
done

# OpenShift CLI
echo ">> openshift client tools"
curl -LO $(get_latest "openshift/origin" openshift-origin-client-tools.*linux-64bit)
tar zxvf openshift-origin*.tar.gz
mv openshift-origin-*/oc /usr/local/bin/oc
mv openshift-origin-*/kubectl /usr/local/bin/ockubectl
rm -rf openshift-origin-*

# Kubernetes
echo ">> kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl --retry 10 --retry-delay 5 -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
mv kubectl /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl

# Kubetail
echo ">> kubetail"
curl -LO https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail
mv kubetail /usr/local/bin/kubetail
chmod +x /usr/local/bin/kubetail

# Kail https://github.com/boz/kail
echo ">> kail"
curl -LO $(get_latest "boz/kail" linux_amd64)
mkdir kail
tar zxvf kail*linux*.tar.gz -C kail
mv kail/kail /usr/local/bin/kail
rm -rf kail kail*linux*.tar.gz

# stern https://github.com/wercker/stern
echo ">> stern"
curl -LO $(get_latest "wercker/stern" linux_amd64)
mv stern_linux_amd64 /usr/local/bin/stern
chmod +x /usr/local/bin/stern

# Istio
echo ">> istio"
curl -LO $(get_latest "istio/istio" "istio-(.*)linux.tar.gz$")
tar zxvf istio-*.tar.gz
rm -f istio-*.tar.gz
mv istio-* /usr/local/
ln -s /usr/local/istio* /usr/local/istio

# Knative CLI https://github.com/cppforlife/knctl
echo ">> knctl"
curl -LO $(get_latest "cppforlife/knctl" linux-amd64)
mv knctl* /usr/local/bin/knctl
chmod +x /usr/local/bin/knctl

# Helm
echo ">> helm"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# IBM provider for Terraform
echo ">> terraform"
curl -LO $(get_latest "IBM-Cloud/terraform-provider-ibm" linux_amd64)
unzip linux_amd64.zip
rm -f linux_amd64.zip
mkdir /usr/local/share/terraform
mv terraform-provider-ibm* /usr/local/share/terraform/terraform-provider-ibm
echo 'providers {
  ibm = "/usr/local/share/terraform/terraform-provider-ibm"
}' > /root/.terraformrc

# Expose configuration to be overriden
mkdir -p /root/mnt/config

# IBM Cloud CLI configuration
rm /root/.bluemix/config.json
touch /root/mnt/config/bx-config.json
ln -s /root/mnt/config/bx-config.json /root/.bluemix/config.json

# IBM Cloud CF configuration
rm /root/.bluemix/.cf/config.json
touch /root/mnt/config/cf-config.json
ln -s /root/mnt/config/cf-config.json /root/.bluemix/.cf/config.json

# IBM Cloud Cloud Functions configuration
touch /root/mnt/config/wsk.props
ln -s /root/mnt/config/wsk.props /root/.wskprops

rm -f /root/.bluemix/plugins/cloud-functions/config.json
mkdir /root/mnt/config/cloud-functions
touch /root/mnt/config/cloud-functions/config.json
ln -s /root/mnt/config/cloud-functions/config.json /root/.bluemix/plugins/cloud-functions/config.json

# IBM Cloud container-registry
mkdir /root/mnt/config/container-registry
ln -s /root/mnt/config/container-registry/config.json /root/.bluemix/plugins/container-registry/config.json

# IBM Cloud container-service
mkdir /root/mnt/config/container-service
ln -s /root/mnt/config/container-service/config.json /root/.bluemix/plugins/container-service/config.json
ln -s /root/mnt/config/container-service/clusters /root/.bluemix/plugins/container-service/clusters

# IBM Cloud vpc-infrastructure
rm -f /root/.bluemix/plugins/vpc-infrastructure/config.json
mkdir /root/mnt/config/vpc-infrastructure
ln -s /root/mnt/config/vpc-infrastructure/config.json /root/.bluemix/plugins/vpc-infrastructure/config.json

# SoftLayer CLI
touch /root/mnt/config/slcli.conf
ln -s /root/mnt/config/slcli.conf /root/.softlayer

# IBM Cloud SoftLayer service
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
