#!/bin/bash
source $1

yum -y install python-requests
foreman-installer --enable-foreman-plugin-ansible --enable-foreman-proxy-plugin-ansible
systemctl restart httpd

file_conf="/usr/lib/python2.7/site-packages/ansible/plugins/callback/foreman.py"
cp $file_conf /root/foreman.py.backup
sed -i.bak "s/http:\/\/localhost:3000/https:\/\/$foreman_hostname/g" $file_conf
sed -i.bak "s/\/etc\/foreman\/client_cert.pem/\/etc\/puppetlabs\/puppet\/ssl\/certs\/$foreman_hostname.pem/g" $file_conf
sed -i.bak "s/\/etc\/foreman\/client_key.pem/\/etc\/puppetlabs\/puppet\/ssl\/private_keys\/$foreman_hostname.pem/g" $file_conf
sed -i.bak "s/'FOREMAN_SSL_VERIFY', \"1\"/'FOREMAN_SSL_VERIFY', \"\/etc\/puppetlabs\/puppet\/ssl\/certs\/ca.pem\"/g" $file_conf

## foreman ou smart-proxy tem que resolver o nome

test -d /usr/share/foreman-proxy/.ssh || mkdir /usr/share/foreman-proxy/.ssh
test -d /usr/share/foreman-proxy/.ansible || mkdir -p /usr/share/foreman-proxy/.ansible
test -f /usr/share/foreman-proxy/.ssh/id_rsa.pub || ssh-keygen -t rsa -f /usr/share/foreman-proxy/.ssh/id_rsa -q -P ""
chown foreman-proxy. /usr/share/foreman-proxy/.ansible
cat > /usr/share/foreman-proxy/.ssh/config << EOF
Host *
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
EOF
chown -R foreman-proxy. /usr/share/foreman-proxy/.ssh
chmod 0700 /usr/share/foreman-proxy/.ssh
chmod 0600 /usr/share/foreman-proxy/.ssh/config

mkdir -p /usr/share/foreman/.ansible/tmp
chown -R foreman. /usr/share/foreman/.ansible

echo "As vms criadas pelo foreman tem que ter essa chave ssh no usuario root"
cat /usr/share/foreman-proxy/.ssh/id_rsa.pub
