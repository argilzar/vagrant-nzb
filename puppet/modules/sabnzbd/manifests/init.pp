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
		creates => '/usr/bin/sabnzbdplus',
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
