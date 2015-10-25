class conteiner-docker {
	if $operatingsystem == 'Debian' {
		$packages = 'docker-engine'
	}
	elsif $operatingsystem == 'Ubuntu' {
		$packages = 'docker-engine'
	}
	elsif $operatingsystem == 'CentOS' {
		$packages = 'docker'
	}

	package { $packages:
		ensure => present,
	}
	->
	service { 'docker':
		ensure => running,
		hasstatus => true,
		hasrestart => true,
		enable => true,
	}
}
