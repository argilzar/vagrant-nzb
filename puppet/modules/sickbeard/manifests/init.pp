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
class sickbeard {
	package { 'python-cheetah' :
		ensure => latest,
	}

	exec { 'get-sickbeard-source':
		cwd => '/mnt/nzb',
		command => 'git clone git://github.com/midgetspy/Sick-Beard.git sickbeard',
		creates => '/mnt/nzb/sickbeard',
	}

	file { '/etc/init.d/sickbeard':
		source => '/mnt/nzb/sickbeard/init.ubuntu',
		require => Exec['get-sickbeard-source'],
	}

	file { '/etc/default/sickbeard':
		source => 'puppet:///modules/sickbeard/sickbeard',
		require => File['/etc/init.d/sickbeard'],
	}

	service { 'sickbeard':
		ensure => running,
		enable => true,
		require => File['/etc/default/sickbeard'],
	}
}
