class local-mirror::client-rpm inherits local-mirror {
	define centos_repo($repo = $title,$repo_ip){
		$local_repo = $repo_ip
		file { $repo:
			ensure => present,
			mode => 0644,
			owner => 'root',
			group => 'root',
			content => template("local-mirror/repo.erb"),
			path => "/etc/yum.repos.d/$repo-homejab.repo",
		}
	}
	define rm_repo($repo = $title){
		file { $repo:
			ensure => absent,
			path => "/etc/yum.repos.d/$repo.repo",
		}
	}

	rm_repo{ ['extra-homejab','puppet-deps-homejab','puppet-homejab','puppetlabs',
		  'update-homejab','CentOS-Base','CentOS-CR','CentOS-Debuginfo','CentOS-fasttrack',
		  'CentOS-Sources','CentOS-Vault','epel-testing']:
	}
	->
	file { '/etc/yum.repos.d/epel.repo':
		ensure => absent,
	}
	->
	centos_repo{ ['base','extras','updates','centosplus','epel','puppetlabs-deps','puppetlabs-products']:
		repo_ip => $local_repo
	}
}
