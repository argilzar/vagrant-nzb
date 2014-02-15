class couchpotato {
	exec { 'Get couchpotato source':
		cwd => '/mnt/nzb',
		command => 'git clone https://github.com/RuudBurger/CouchPotatoServer.git couchpotato',
		creates => '/mnt/nzb/couchpotato',
	}
}
