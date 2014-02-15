class sabnzbd {
	exec { 'Enable multiverse':
		cwd => '/mnt/nzb',
		command => 'sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list && apt-get update -qq && touch /mnt/nzb/.multiverse',
		creates => '/mnt/nzb/.multiverse',
	}

	package { 'sabnzbdplus' :
		ensure => latest,
		require => Exec['Enable multiverse'],
	}

}
