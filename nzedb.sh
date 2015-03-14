#!/bin/bash
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
SCRIPT=nzedb
INSTALL_PACKAGES="git python-mysqldb php5 php5-dev php-pear php5-gd php5-mysql php5-curl php5-fpm nginx software-properties-common unrar python-software-properties lame mediainfo libav-tools x264 memcached php5-memcached"

source /vagrant/config.sh

#Enable multiverse for unrar

my_msg "Enabling multiverse" 
sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list
apt-get -qq update
apt-get -y -qq upgrade
apt-get -y -qq dist-upgrade

which apache2
if [ $? = "0" ]; then
	apt-get -y purge apache2
	apt-get -y autoremove
fi

if [ "$NZEDB_HAS_MYSQL" = "1" ]; then
	which mysqld
	if [ $? = "1" ]; then
	 my_msg "Installing mysql" 
	 INSTALL_PACKAGES="$INSTALL_PACKAGES"
	 export DEBIAN_FRONTEND=noninteractive
	 apt-get install --assume-yes mysql-server-5.6
	 unset DEBIAN_FRONTEND
	 MYSQL_HOST=127.0.0.1
	fi
else
	MYSQL_HOST=$NZEDB_MYSQL_HOST
fi


#Make dir for configs and stuff
if [ ! -d $NZEDB_DATA ]; then
 mkdir $NZEDB_DATA
fi

#Install packages
for PACKAGE in $INSTALL_PACKAGES; do
 my_check_install $PACKAGE
done;

which apparmor_parser
if [ $? = "0" ]; then
	my_msg "Removing apparmor" 
	apt-get -y purge apparmor
	
fi


#Checkout nzedb source
if [ ! -d $NZEDB_INSTALL ]; then
 git clone $NZEDB_SOURCE_REPO $NZEDB_INSTALL
 chmod 777 $NZEDB_INSTALL
 cd $NZEDB_INSTALL
 chmod -R 755 .
 chmod 777 $NZEDB_INSTALL/libs/smarty/templates_c
 chmod -R 777 $NZEDB_INSTALL/www/covers
 chmod 777 $NZEDB_INSTALL/www
 chmod -R 777 $NZEDB_INSTALL/resources
 chmod 777 $NZEDB_INSTALL/www/install
fi

python /vagrant/config.py -i /etc/php5/cli/php.ini -g PHP -s register_globals -v Off
python /vagrant/config.py -i /etc/php5/cli/php.ini -g PHP -s max_execution_time -v 120
python /vagrant/config.py -i /etc/php5/cli/php.ini -g PHP -s memory_limit -v 1024M
python /vagrant/config.py -i /etc/php5/cli/php.ini -g Date -s date.timezone -v Europe/Copenhagen
 
python /vagrant/config.py -i /etc/php5/fpm/php.ini -g PHP -s register_globals -v Off
python /vagrant/config.py -i /etc/php5/fpm/php.ini -g PHP -s max_execution_time -v 120
python /vagrant/config.py -i /etc/php5/fpm/php.ini -g PHP -s memory_limit -v 1024M
python /vagrant/config.py -i /etc/php5/fpm/php.ini -g Date -s date.timezone -v Europe/Copenhagen

#python /vagrant/config.py -i /etc/php5/fpm/php.ini -g Session -s session.save_handler -v memcached
#python /vagrant/config.py -i /etc/php5/fpm/php.ini -g Session -s session.save_path -v tcp://localhost:11211

service nginx restart
service php5-fpm restart

if [ -f /etc/nginx/sites-enabled/default ]; then
  unlink /etc/nginx/sites-enabled/default
fi

if [ ! -f /etc/nginx/sites-available/nZEDb ]; then
	mv /vagrant/nZEDb.nginx /etc/nginx/sites-available/nZEDb
fi

if [ ! -f /etc/nginx/sites-enabled/nZEDb ]; then
	ln -s /etc/nginx/sites-available/nZEDb /etc/nginx/sites-enabled/nZEDb
	service nginx restart
fi


my_msg "Creating MySQL user and database"
mysql -u root -e "create database IF NOT EXISTS nzedb default character set utf8"
mysql -u root -e "grant all privileges on nzedb.* to nzedb@localhost identified by 'nzedb'"
mysql -u root -e "GRANT FILE ON *.* TO 'nzedb'@'localhost'"

#Write info for other services
my_update_settings NZEDB_PRIVATE_IP `ifconfig eth0 | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d: -f2 | egrep "[0-9\.]+" -o` $ENVIRONMENT_FILE


#Has the IP and APIKEY
source $ENVIRONMENT_FILE
#Provisioning succeeded



exit 0
