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
INSTALL_PACKAGES="git"
SCRIPT=couchpotato

source /vagrant/config.sh

#Make dir for configs and stuff
if [ ! -d $COUCHPOTATO_DATA ]; then
 mkdir $COUCHPOTATO_DATA
 chown -R $COUCHPOTATO_USER:$COUCHPOTATO_USER $COUCHPOTATO_DATA
 ln -s $COUCHPOTATO_DATA /home/vagrant/.couchpotato
 chown -R $COUCHPOTATO_USER:$COUCHPOTATO_USER /home/vagrant/.couchpotato
fi

[ -f $COUCHPOTATO_CONFIG_FILE ] || touch $COUCHPOTATO_CONFIG_FILE
my_update_settings RUN_AS $COUCHPOTATO_USER $COUCHPOTATO_CONFIG_FILE
my_update_settings APP_PATH $COUCHPOTATO_INSTALL $COUCHPOTATO_CONFIG_FILE
my_update_settings DATA_DIR $COUCHPOTATO_DATA $COUCHPOTATO_CONFIG_FILE


#Install packagess
for PACKAGE in $INSTALL_PACKAGES; do
 my_check_install $PACKAGE
done;

#Checkout couchpotato source
if [ ! -d $COUCHPOTATO_INSTALL ]; then
 git clone $COUCHPOTATO_SOURCE_REPO $COUCHPOTATO_INSTALL
fi

#Init
if [ ! -f /etc/init.d/couchpotato ]; then
 my_msg "Adding couchpotato init script"
 cp /opt/couchpotato/init/ubuntu /etc/init.d/couchpotato
 chmod +x /etc/init.d/couchpotato
 update-rc.d couchpotato defaults
 my_msg "Starting couchpotato"
 /etc/init.d/couchpotato start
fi

#Write info for other services
my_msg "Write info for other services"
my_update_settings COUCHPOTATO_PRIVATE_IP `ifconfig eth1 | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d: -f2 | egrep "[0-9\.]+" -o` $ENVIRONMENT_FILE
#Has the IP and APIKEY of 
my_msg "Sourcing environment"
source $ENVIRONMENT_FILE

my_msg "Stopping couchpotato"
/etc/init.d/couchpotato stop

my_msg "Writing config for couchpotato"
#Update ini file
#python /vagrant/config.py -i $COUCHPOTATO_INI -g sabnzbd -s enabled -v 1
#python /vagrant/config.py -i $COUCHPOTATO_INI -g sabnzbd -s category -v movies
#python /vagrant/config.py -i $COUCHPOTATO_INI -g sabnzbd -s host -v "http://$SAB_PRIVATE_IP:$SAB_PORT"
#python /vagrant/config.py -i $COUCHPOTATO_INI -g sabnzbd -s api_key -v "$SAB_API_KEY"
my_msg "Starting again"
/etc/init.d/couchpotato start
my_msg "Done setting up couchpotato"
#Provisioning succeeded
exit 0

