#!/bin/bash
# Copyright 2013 Brian Bischoff <admin@argilzar.com>
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
INSTALL_PACKAGES="git python-mysqldb php5 php5-dev php-pear php5-gd php5-mysql php5-curl apache2 software-properties-common unrar python-software-properties lame mediainfo ffmpeg x264"

source /vagrant/config.sh

#Enable multiverse for unrar
if [ ! -f /etc/apt/sources.list.d/multiverse.list ];then
 my_msg "Enabling multiverse" 
 echo "deb http://archive.ubuntu.com/ubuntu raring multiverse" > /etc/apt/sources.list.d/multiverse.list
 echo "deb-src http://archive.ubuntu.com/ubuntu raring multiverse" >> /etc/apt/sources.list.d/multiverse.list
 echo "deb http://archive.ubuntu.com/ubuntu raring-updates multiverse" >> /etc/apt/sources.list.d/multiverse.list
 echo "deb-src http://archive.ubuntu.com/ubuntu raring-updates multiverse" >> /etc/apt/sources.list.d/multiverse.list
 apt-get -qq update
 apt-get -y -qq upgrade
fi

if [ "$NZEDB_HAS_MYSQL" = "1" ]; then
 INSTALL_PACKAGES="$INSTALL_PACKAGES mysql-client libmysqlclient-dev"
 export DEBIAN_FRONTEND=noninteractive
 apt-get install --assume-yes mysql-server
 unset DEBIAN_FRONTEND
 MYSQL_HOST=127.0.0.1 
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

#Checkout nzedb source
if [ ! -d $NZEDB_INSTALL ]; then
 git clone $NZEDB_SOURCE_REPO $NZEDB_INSTALL
 chmod 777 $NZEDB_INSTALL
 cd $NZEDB_INSTALL
 chmod -R 755 .
 chmod 777 $NZEDB_INSTALL/www/lib/smarty/templates_c
 chmod -R 777 $NZEDB_INSTALL/www/covers
 chmod 777 $NZEDB_INSTALL/www
 chmod 777 $NZEDB_INSTALL/www/install
 chmod -R 777 $NZEDB_INSTALL/nzbfiles
fi

python /vagrant/config.py -i /etc/php5/cli/php.ini -g PHP -s register_globals -v Off
python /vagrant/config.py -i /etc/php5/cli/php.ini -g PHP -s max_execution_time -v 120
python /vagrant/config.py -i /etc/php5/cli/php.ini -g PHP -s memory_limit -v 1024M
python /vagrant/config.py -i /etc/php5/cli/php.ini -g Date -s date.timezone -v Europe/Copenhagen

python /vagrant/config.py -i /etc/php5/apache2/php.ini -g PHP -s register_globals -v Off
python /vagrant/config.py -i /etc/php5/apache2/php.ini -g PHP -s max_execution_time -v 120
python /vagrant/config.py -i /etc/php5/apache2/php.ini -g PHP -s memory_limit -v 1024M
python /vagrant/config.py -i /etc/php5/apache2/php.ini -g Date -s date.timezone -v Europe/Copenhagen


if [ ! -f /etc/apache2/sites-available/nZEDb ]; then
echo "<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName localhost

    # These paths should be fine
    DocumentRoot /var/www/nZEDb/www
    ErrorLog /var/log/apache2/error.log
    LogLevel warn
</VirtualHost>" > /etc/apache2/sites-available/nZEDb

 a2dissite default
 a2ensite nZEDb
 a2enmod rewrite
 [ -f /etc/apache2/conf.d/name ] || echo "ServerName localhost" > /etc/apache2/conf.d/name
 service apache2 restart
fi

#Write info for other services
my_update_settings NZEDB_PRIVATE_IP `ifconfig eth1 | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d: -f2 | egrep "[0-9\.]+" -o` $ENVIRONMENT_FILE


#Has the IP and APIKEY
source $ENVIRONMENT_FILE
#Provisioning succeeded



exit 0
