#!/bin/bash
source $1
export proxy_hostname=$puppet_hostname
export ip_proxy="$(ip -o -4 a s $(ip r s | grep default | awk '{print $5}' | head -n1) | awk '{print $4}' | cut -d \/ -f 1)"

source shell-functions/configure-ssh.sh
source shell-functions/installer-repo.sh
source shell-functions/gen_proxy.sh

foreman-installer \
  --no-enable-foreman \
  --no-enable-foreman-cli \
  --no-enable-foreman-plugin-bootdisk \
  --no-enable-foreman-plugin-setup \
  --enable-puppet \
  --puppet-server-ca=false \
  --puppet-server-foreman-url=https://$foreman_hostname \
  --enable-foreman-proxy \
  --foreman-proxy-puppetca=false \
  --foreman-proxy-tftp=false \
  --foreman-proxy-foreman-base-url=https://$foreman_hostname \
  --foreman-proxy-trusted-hosts=$foreman_hostname \
  --foreman-proxy-trusted-hosts=$proxy_hostname \
  --foreman-proxy-oauth-consumer-key="$consumer_key"\
  --foreman-proxy-oauth-consumer-secret="$consumer_secret"

git clone https://github.com/narigacdo/home-jab.git /etc/puppetlabs/code/environments/home_jab
