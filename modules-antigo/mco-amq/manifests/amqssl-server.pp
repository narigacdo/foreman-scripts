class mco-amq::amqssl-server inherits mco-amq{
		$keystore_pass = $keystore_pass
		$trueststore_pass = $trueststore_pass
	if $operatingsystem == 'Debian' {
		$path_fileconf = '/etc/activemq/instances-available/main/activemq.xml'
		include mco-amq::activemq-enable
	}
	elsif $operatingsystem == 'Ubuntu' {
		$path_fileconf = '/etc/activemq/instances-available/main/activemq.xml'
		include mco-amq::activemq-enable
	}
	elsif $operatingsystem == 'CentOS' {
		$path_fileconf = '/etc/activemq/activemq.xml'
	}

	package{ 'activemq':
		ensure => present,
		allow_virtual => true
	}

	file{ 'activemq.xml':
		ensure => present,
		content => template("mco-amq/activemq.ssl.$operatingsystem.xml.erb"),
		path => $path_fileconf,
		owner => 'root',
		group => 'root',
		mode => '0644',
		require => Package['activemq'],
		notify => Service['activemq']
	}

	file{ 'activemq':
		ensure => directory,
		path => '/usr/share/activemq',
		owner => 'activemq',
		group => 'root',
		mode => '0755',
		require => Package['activemq']
	}

	service{ 'activemq':
		ensure => running,
		hasstatus => true,
		hasrestart => true,
		enable => true,
		require => File['activemq.xml'],
	}
}
