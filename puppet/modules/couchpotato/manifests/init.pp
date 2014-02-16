# Copyright 2013-2014 Brian Bischoff <admin@argilzar.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
class couchpotato {
	exec { 'get-couchpotato-source':
		cwd => '/mnt/nzb',
		command => 'git clone git://github.com/RuudBurger/CouchPotatoServer.git couchpotato',
		timeout => 0,
		creates => '/mnt/nzb/couchpotato',
	}

	file { '/etc/init.d/couchpotato':
		source => '/mnt/nzb/couchpotato/init/ubuntu',
		require => Exec['get-couchpotato-source'],
	}

	file { '/etc/default/couchpotato':
		source => 'puppet:///modules/couchpotato/couchpotato',
		require => File['/etc/init.d/couchpotato'],
	}

	service { 'couchpotato':
		ensure => running,
		enable => true,
		require => File['/etc/default/couchpotato'],
	}

}
