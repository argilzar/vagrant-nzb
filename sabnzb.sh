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
INSTALL_PACKAGES="sabnzbdplus"
SCRIPT=sabnzb

source /vagrant/config.sh

#Enable multiverse for easy install of sabnzbdplus
if [ ! -f /etc/apt/sources.list.d/multiverse.list ];then
 my_msg "Enabling multiverse" 
 echo "deb http://archive.ubuntu.com/ubuntu raring multiverse" > /etc/apt/sources.list.d/multiverse.list
 echo "deb-src http://archive.ubuntu.com/ubuntu raring multiverse" >> /etc/apt/sources.list.d/multiverse.list
 echo "deb http://archive.ubuntu.com/ubuntu raring-updates multiverse" >> /etc/apt/sources.list.d/multiverse.list
 echo "deb-src http://archive.ubuntu.com/ubuntu raring-updates multiverse" >> /etc/apt/sources.list.d/multiverse.list
 apt-get -qq update
fi

#Install packages
for PACKAGE in $INSTALL_PACKAGES; do
 my_check_install $PACKAGE
done;

#Update default settings
my_update_settings USER $SAB_USER $SAB_CONFIG_FILE
my_update_settings CONFIG $SAB_INI $SAB_CONFIG_FILE
my_update_settings HOST $SAB_HOST $SAB_CONFIG_FILE
my_update_settings PORT $SAB_PORT $SAB_CONFIG_FILE

#Restart to get new settings
service sabnzbdplus status
if [ $? -ne 0 ]; then
    service sabnzbdplus start
else
	service sabnzbdplus stop
	service sabnzbdplus start
fi

#Write info for other services
my_update_settings SAB_PRIVATE_IP `ifconfig eth1 | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d: -f2 | egrep "[0-9\.]+" -o` $ENVIRONMENT_FILE
my_update_settings SAB_API_KEY `cat $SAB_INI | egrep -o "^api_key\s?\=\s?([a-z0-9]+)" | cut  -d"=" -f2 |  tr -d ' '` $ENVIRONMENT_FILE
COMPLETE_DIR=`cat $SAB_INI | egrep -o "^complete_dir\s?\=\s?(.*)" | cut  -d"=" -f2 | tr -d ' '`
if [ "$(echo $COMPLETE_DIR | head -c 1)" = "/" ];then
 my_update_settings SAB_COMPLETE_DIR $COMPLETE_DIR $ENVIRONMENT_FILE
else
 my_update_settings SAB_COMPLETE_DIR "$(dirname $SAB_INI)/$COMPLETE_DIR" $ENVIRONMENT_FILE
fi

my_msg "Done setting up sabnzb"

#Provisioning succeeded
exit 0
