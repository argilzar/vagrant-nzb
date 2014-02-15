node 'combined' {
	package { 'htop' :
		ensure => latest,
	}	
	package { 'git' :
		ensure => latest,
	}	

	host { 'combined.example.com':
	    ensure => 'present',       
    	target => '/etc/hosts',    
    	ip => '127.0.1.1',         
    	host_aliases => ['combined']
	}

	if $use_sabnzbd {
		include sabnzbd
	}

	if $use_sickbeard {
		include sickbeard
	}

	if $use_couchpotato {
		include couchpotato
	}

	if $use_headphones {
		include headphones
	}	

}