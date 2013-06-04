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
INSTALL_PACKAGES="git python-cheetah"
SCRIPT=sickbeard

source /vagrant/config.sh

#Make dir for configs and stuff
if [ ! -d $SICKBEARD_DATA ]; then
 mkdir $SICKBEARD_DATA
fi

[ -f $SICKBEARD_CONFIG_FILE ] || touch $SICKBEARD_CONFIG_FILE
my_update_settings SB_USER $SICKBEARD_USER $SICKBEARD_CONFIG_FILE
my_update_settings SB_HOME $SICKBEARD_INSTALL $SICKBEARD_CONFIG_FILE
my_update_settings SB_DATA $SICKBEARD_DATA $SICKBEARD_CONFIG_FILE

#Install packages
for PACKAGE in $INSTALL_PACKAGES; do
 my_check_install $PACKAGE
done;

#Checkout sickbeard source
if [ ! -d $SICKBEARD_INSTALL ]; then
 git clone $SICKBEARD_SOURCE_REPO $SICKBEARD_INSTALL
fi

#Init
if [ ! -f /etc/init.d/sickbeard ]; then
 my_msg "Adding sickbeard init script"
 ln -s /opt/sickbeard/init.ubuntu /etc/init.d/sickbeard
 chmod +x /etc/init.d/sickbeard
 update-rc.d sickbeard defaults
 my_msg "Starting sickbeard daemon"
 /etc/init.d/sickbeard start > /dev/null 2>&1
 my_msg "Stop the daemon and write the new config"
 my_update_settings SB_OPTS " --config=$SICKBEARD_INI" $SICKBEARD_CONFIG_FILE
fi


#Write info for other services
my_update_settings SICKBEARD_PRIVATE_IP `ifconfig eth1 | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d: -f2 | egrep "[0-9\.]+" -o` $ENVIRONMENT_FILE
#Has the IP and APIKEY
source $ENVIRONMENT_FILE
#Update ini file
python /vagrant/config.py -i $SICKBEARD_ORIGINAL_INI -g General -s nzb_method -v sabnzbd
python /vagrant/config.py -i $SICKBEARD_ORIGINAL_INI -g SABnzbd -s sab_host -v "\"http://$SAB_PRIVATE_IP:$SAB_PORT/\""
python /vagrant/config.py -i $SICKBEARD_ORIGINAL_INI -g SABnzbd -s sab_apikey -v "\"$SAB_API_KEY\""
[ $SICKBEARD_UPDATE_COMPLETE_DIR -eq "1" ] && python /vagrant/config.py -i $SICKBEARD_ORIGINAL_INI -g General -s tv_download_dir -v "\"$SAB_COMPLETE_DIR\""
#Remove all empty lines sickbeard doesnt like them for some reason
sed '/^$/d' $SICKBEARD_ORIGINAL_INI > $SICKBEARD_INI
my_msg "restarting sickbeard"
/etc/init.d/sickbeard stop  > /dev/null 2>&1
/etc/init.d/sickbeard start  > /dev/null 2>&1
my_msg "Done setting up sickbeard"
#Provisioning succeeded
exit 0

