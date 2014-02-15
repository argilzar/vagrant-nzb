class sickbeard {
	package { 'python-cheetah' :
		ensure => latest,
	}

	exec { 'Get sickbeard source':
		cwd => '/mnt/nzb',
		command => 'git clone git://github.com/midgetspy/Sick-Beard.git sickbeard',
		creates => '/mnt/nzb/sickbeard',
	}

	


}
