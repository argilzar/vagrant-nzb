#!/usr/bin/env bash
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

#Couchpotato
COUCHPOTATO_SOURCE_REPO="https://github.com/RuudBurger/CouchPotatoServer.git"
COUCHPOTATO_INSTALL="/opt/couchpotato"
COUCHPOTATO_USER="vagrant"
COUCHPOTATO_DATA="$DATA_DIR/couchpotato"
COUCHPOTATO_INI="$COUCHPOTATO_DATA/settings.conf"
COUCHPOTATO_CONFIG_FILE="/etc/default/couchpotato"
COUCHPOTATO_HOST="0.0.0.0"
COUCHPOTATO_PORT="5050"

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
 echo "$1=$2" >> $3
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


