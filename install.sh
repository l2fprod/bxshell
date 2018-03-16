
# NVM for Node.JS
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash
source /root/.nvm/nvm.sh
nvm install 6.9.1
npm install -g nodemon
npm install -g serverless serverless-openwhisk@latest --unsafe-perm spawn-sync
serverless slstats -d
npm install -g @ibm-functions/shell --unsafe-perm
nvm cache clear

# SoftLayer
pip install softlayer

# Bluemix CLI
curl -fsSL https://clis.ng.bluemix.net/install/linux > /tmp/bxinstall.sh
sh /tmp/bxinstall.sh
rm /tmp/bxinstall.sh

# Bluemix CLI plugins
bx plugin install activity-tracker -f -r Bluemix
bx plugin install cloud-functions -f -r Bluemix
bx plugin install container-registry -f -r Bluemix
bx plugin install container-service -f -r Bluemix
bx plugin install dev -f -r Bluemix
bx plugin install logging-cli -r Bluemix

# Kubernetes
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
  mv kubectl /usr/local/bin/kubectl && \
  chmod +x /usr/local/bin/kubectl

# Kubetail
curl -LO https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail && \
  mv kubetail /usr/local/bin/kubetail && \
  chmod +x /usr/local/bin/kubetail

# Istio
(cd /usr/local && curl -L https://git.io/getLatestIstio | sh -)
ln -s /usr/local/istio* /usr/local/istio

# Helm
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

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

# IBM provider for Terraform
curl -LO $(curl -I https://github.com/IBM-Cloud/terraform-provider-ibm/releases/latest | grep Location | awk '{print $2}' | sed 's/tag/download/g' | tr -d '[:space:]')/linux_amd64.zip && \
  unzip linux_amd64.zip && \
  rm -f linux_amd64.zip && \
  mkdir /usr/local/share/terraform && \
  mv terraform-provider-ibm /usr/local/share/terraform && \
  echo 'providers {
  ibm = "/usr/local/share/terraform/terraform-provider-ibm"
}' > /root/.terraformrc

# Helm configuration
mkdir /root/mnt/config/helm
ln -s /root/mnt/config/helm /root/.helm

# Docker configuration
mkdir /root/mnt/config/docker
ln -s /root/mnt/config/docker /root/.docker