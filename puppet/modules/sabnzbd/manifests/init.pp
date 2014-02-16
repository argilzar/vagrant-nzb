class sabnzbd {
	file { '/etc/apt/sources.list.d/multiverse.list':
		source => 'puppet:///modules/sabnzbd/multiverse.list',
	}

	file { '/etc/default/sabnzbdplus':
		source => 'puppet:///modules/sabnzbd/sabnzbdplus',
		require => Package['sabnzbdplus'],
	}

	exec {'apt-get update':
		command => 'apt-get -qq update',
		require => File['/etc/apt/sources.list.d/multiverse.list'],
	}

	package { 'sabnzbdplus' :
		ensure => latest,
		require => Exec['apt-get update'],
	}

	service { 'sabnzbdplus':
		ensure => running,
		enable => true,
		require => File['/etc/default/sabnzbdplus'],
	}

}
