#!/usr/bin/env bash
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
DATA_DIR="/mnt/nzb"
ENVIRONMENT_FILE="$DATA_DIR/environment.sh"

#Sabnzbd+ settings
SAB_CONFIG_FILE="/etc/default/sabnzbdplus"
SAB_USER="vagrant"
SAB_INI="$DATA_DIR/sabnzbdplus/config.ini"
SAB_HOST="0.0.0.0"
SAB_PORT="8080"

#Sickbeard
SICKBEARD_SOURCE_REPO="git://github.com/midgetspy/Sick-Beard.git"
SICKBEARD_INSTALL="/opt/sickbeard"
SICKBEARD_USER="vagrant"
SICKBEARD_DATA="$DATA_DIR/sickbeard"
SICKBEARD_ORIGINAL_INI="$SICKBEARD_DATA/config.ini"
SICKBEARD_INI="$SICKBEARD_DATA/my.config.ini"
SICKBEARD_CONFIG_FILE="/etc/default/sickbeard"
SICKBEARD_HOST="0.0.0.0"
SICKBEARD_PORT="8081"
SICKBEARD_UPDATE_COMPLETE_DIR="1"

#Headphones
HEADPHONES_SOURCE_REPO="https://github.com/rembo10/headphones.git"
HEADPHONES_INSTALL="/opt/headphones"
HEADPHONES_USER="vagrant"
HEADPHONES_DATA="$DATA_DIR/headphones"
HEADPHONES_ORIGINAL_INI="$HEADPHONES_DATA/config.ini"
HEADPHONES_INI="$HEADPHONES_DATA/my.config.ini"
HEADPHONES_CONFIG_FILE="/etc/default/headphones"
HEADPHONES_HOST="0.0.0.0"
HEADPHONES_PORT="8181"
HEADPHONES_UPDATE_COMPLETE_DIR="1"

#Couchpotato
COUCHPOTATO_SOURCE_REPO="https://github.com/RuudBurger/CouchPotatoServer.git"
COUCHPOTATO_INSTALL="/opt/couchpotato"
COUCHPOTATO_USER="vagrant"
COUCHPOTATO_DATA="$DATA_DIR/couchpotato"
COUCHPOTATO_INI="$COUCHPOTATO_DATA/settings.conf"
COUCHPOTATO_CONFIG_FILE="/etc/default/couchpotato"
COUCHPOTATO_HOST="0.0.0.0"
COUCHPOTATO_PORT="5050"

#nZEDb newznab clone
NZEDB_SOURCE_REPO="https://github.com/nZEDb/nZEDb.git"
NZEDB_INSTALL="/var/www/nZEDb"
NZEDB_USER="vagrant"
NZEDB_DATA="$DATA_DIR/nzedb"
NZEDB_CONFIG_FILE="/etc/default/sickbeard"
NZEDB_HOST="0.0.0.0"
NZEDB_PORT="445"
#Set to 1 to install mysql also, I recomend using another server for this
NZEDB_HAS_MYSQL="0"
NZEDB_MYSQL_HOST="192.168.1.188"
NZEDB_MYSQL_USER="nzedb"
NZEDB_MYSQL_PASS="nzedb"
NZEDB_MYSQL_DB="nzedb"

function my_msg {
  echo "[$SCRIPT] $1" 
}

function my_check_install {
 dpkg -l $1 > /dev/null 2>&1
 if [ $? == '0' ]; then
  my_msg "$1 installed"
 else
  apt-get -y -qq install $1
 fi
}

function my_update_settings {
 sed -i "/$1/d" $3 > /dev/null
 echo "$1=\"$2\"" >> $3
}

#Check for nzb mount, this needs to be present
if [ ! -d $DATA_DIR ]; then
 my_msg "$DATA_DIR is not mounted"
 exit 1
fi

if [ ! -f $ENVIRONMENT_FILE ]; then
 echo "#!/usr/bin/env bash" > $ENVIRONMENT_FILE
 echo "#This file is auto updated when provisioning, you should not change it" >> $ENVIRONMENT_FILE
fi


