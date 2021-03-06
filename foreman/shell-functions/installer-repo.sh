#!/bin/bash
source shell-functions/determine_so

case `get_so -s` in
	CentOS)
		yum -y install https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm
		yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
		yum -y install https://yum.theforeman.org/releases/1.21/el7/x86_64/foreman-release.rpm
		yum install -y dos2unix foreman-installer
	;;
	Ubuntu)
		apt-get -y install ca-certificates
		wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
		dpkg -i puppetlabs-release-pc1-xenial.deb
		echo "deb http://deb.theforeman.org/ xenial 1.16" > /etc/apt/sources.list.d/foreman.list
		echo "deb http://deb.theforeman.org/ plugins 1.16" >> /etc/apt/sources.list.d/foreman.list
		apt-get -y install ca-certificates
		wget -q https://deb.theforeman.org/pubkey.gpg -O- | apt-key add -
		apt-get update
		apt-get -y install foreman-installer dos2unix
		rm puppetlabs-release-pc1-xenial.deb
	;;
	Debian)
                apt-get -y install ca-certificates
                wget wget https://apt.puppetlabs.com/puppet5-release-stretch.deb
                dpkg -i puppet5-release-stretch.deb
                echo "deb http://deb.theforeman.org/ stretch 1.16" > /etc/apt/sources.list.d/foreman.list
                echo "deb http://deb.theforeman.org/ plugins 1.16" >> /etc/apt/sources.list.d/foreman.list
                apt-get -y install ca-certificates
                wget -q https://deb.theforeman.org/pubkey.gpg -O- | apt-key add -
                apt-get update
                apt-get -y install foreman-installer dos2unix
                rm puppet5-release-stretch.deb
	;;
esac
