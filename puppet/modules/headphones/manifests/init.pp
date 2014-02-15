class headphones {
	exec { 'Get headphones source':
		cwd => '/mnt/nzb',
		command => 'git clone https://github.com/rembo10/headphones.git headphones',
		creates => '/mnt/nzb/headphones',
	}


}
