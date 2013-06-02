#!/bin/bash
#Provisioning script for sabnzbdpluss
#Author: Brian Bischoff <admin@argilzar.com>
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
/etc/init.d/sabnzbdplus restart

#Write info for other services
my_update_settings SAB_PRIVATE_IP `ifconfig eth1 | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d: -f2 | egrep "[0-9\.]+" -o` $ENVIRONMENT_FILE
my_update_settings SAB_API_KEY `cat $SAB_INI | egrep -o "^api_key\s?\=\s?([a-z0-9]+)" | cut  -d"=" -f2 |  tr -d ' '` $ENVIRONMENT_FILE

my_msg "Done setting up sabnzb"

#Provisioning succeeded
exit 0
