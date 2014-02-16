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
INSTALL_PACKAGES="git"
SCRIPT=headphones

source /vagrant/config.sh

#Make dir for configs and stuff
if [ ! -d $HEADPHONES_DATA ]; then
 mkdir $HEADPHONES_DATA
fi

[ -f $HEADPHONES_CONFIG_FILE ] || touch $HEADPHONES_CONFIG_FILE
my_update_settings HP_USER $HEADPHONES_USER $HEADPHONES_CONFIG_FILE
my_update_settings HP_HOME $HEADPHONES_INSTALL $HEADPHONES_CONFIG_FILE
my_update_settings HP_DATA $HEADPHONES_DATA $HEADPHONES_CONFIG_FILE
my_update_settings HP_PORT $HEADPHONES_PORT $HEADPHONES_CONFIG_FILE

#Install packages
for PACKAGE in $INSTALL_PACKAGES; do
 my_check_install $PACKAGE
done;

#Checkout HEADPHONES source
if [ ! -d $HEADPHONES_INSTALL ]; then
 git clone $HEADPHONES_SOURCE_REPO $HEADPHONES_INSTALL
fi


#Init
if [ ! -f /etc/init.d/headphones ]; then
 my_msg "Adding headphones init script"
 ln -s /opt/headphones/init.ubuntu /etc/init.d/headphones
 chmod +x /etc/init.d/headphones
 update-rc.d headphones defaults
 my_msg "Starting headphones daemon"
 /etc/init.d/headphones start
 my_msg "Stop the daemon and write the new config"
 /etc/init.d/headphones stop
 my_update_settings HP_OPTS " --config=$HEADPHONES_INI" $HEADPHONES_CONFIG_FILE
else
 #Otherwise we overwrite our own settings
 cat $HEADPHONES_INI > $HEADPHONES_ORIGINAL_INI
fi


#Write info for other services
my_update_settings HEADPHONES_PRIVATE_IP `ifconfig eth1 | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d: -f2 | egrep "[0-9\.]+" -o` $ENVIRONMENT_FILE
#Has the IP and APIKEY
source $ENVIRONMENT_FILE

#Update ini file
#python /vagrant/config.py -i $HEADPHONES_ORIGINAL_INI -g General -s nzb_method -v sabnzbd
python /vagrant/config.py -i $HEADPHONES_ORIGINAL_INI -g SABnzbd -s sab_host -v "\"http://$SAB_PRIVATE_IP:$SAB_PORT/\""
python /vagrant/config.py -i $HEADPHONES_ORIGINAL_INI -g SABnzbd -s sab_apikey -v "\"$SAB_API_KEY\""
[ $HEADPHONES_UPDATE_COMPLETE_DIR -eq "1" ] && python /vagrant/config.py -i $HEADPHONES_ORIGINAL_INI -g General -s download_dir -v "\"$SAB_COMPLETE_DIR\""
#Remove all empty lines HEADPHONES doesnt like them for some reason
sed '/^$/d' $HEADPHONES_ORIGINAL_INI > $HEADPHONES_INI
my_msg "restarting headphones"
/etc/init.d/headphones stop
/etc/init.d/headphones start
my_msg "Done setting up headphones"
#Provisioning succeeded
exit 0

