class local-mirror::client-deb inherits local-mirror {
	include zabbix::agent
	file { 'sources.list':
		ensure => present,
		content => template("local-mirror/$operatingsystem.erb"),
		path => '/etc/apt/sources.list',
		mode => 0644,
		owner => 'root',
		group => 'root'
	}

	file { 'puppet.list':
		ensure => present,
		content => template("local-mirror/puppet.$operatingsystem.erb"),
		path => '/etc/apt/sources.list.d/puppetlabs.list',
		mode => 0644,
		owner => 'root',
		group => 'root'
	}

	file { 'zabbix.list':
		ensure => present,
		content => template("local-mirror/zabbix.$operatingsystem.erb"),
		path => '/etc/apt/sources.list.d/zabbix.list',
		mode => 0644,
		owner => 'root',
		group => 'root',
		require => Exec['install-repo']
	}

	file { 'repository.deb':
		ensure => present,
		source => "puppet:///modules/local-mirror/$operatingsystem.deb",
		path => '/root/puppetlabs-repo.deb',
		mode => 0644,
		owner => 'root',
		group => 'root'
	}
	->
	exec { 'install-pkg':
		path => '/bin:/usr/bin:/sbin:/usr/sbin',
		command => 'dpkg -i /root/puppetlabs-repo.deb',
		unless => 'dpkg -l puppetlabs-release'
	}
	~>
	exec { 'apt-update':
		path => '/bin:/usr/bin:/sbin:/usr/sbin',
		command => 'apt-get update',
		subscribe => File['puppet.list','sources.list'],
		refreshonly => true
	}
}
