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
class sabnzbd {
	#package { ["python-configobj","python-feedparser","python-dbus","python-openssl","python-support","python-yenc","par2","unrar","unzip"]:
#		ensure => latest,
#	}

	exec { 'get-sabnzbdplus-source':
		cwd => '/mnt/nzb',
		command => 'git clone git://github.com/sabnzbd/sabnzbd.git sabnzbdplus',
		timeout => 0,
		creates => '/mnt/nzb/sabnzbdplus',
	}

	file { '/etc/init.d/sabnzbdplus':
		source => 'puppet:///modules/sabnzbd/init.ubuntu',
		require => Exec['get-sabnzbdplus-source'],
	}

	file { '/etc/default/sabnzbdplus':
		source => 'puppet:///modules/sabnzbd/sabnzbdplus',
		require => File['/etc/init.d/sabnzbdplus'],
	}

	service { 'sabnzbdplus':
		ensure => running,
		enable => true,
		require => File['/etc/default/sabnzbdplus'],
	}
}