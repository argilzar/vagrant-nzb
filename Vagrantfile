# -*- mode: ruby -*-
# vi: set ft=ruby :
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

Vagrant.configure("1") do |config|
  #The ubuntu cloud image, will be downloaded for the first box
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.box = "raring-amd64-vagrant"
  
  #Default location for all the setting files, incomplete downloads and cache
  #You can not omit this unless you change the defaults in the provisioning scripts
  #The mount point should be /mnt/nzb always
  #If you do not change this then nzb folder will be created in current dir
  config.vm.share_folder "nzb", "/mnt/nzb", "nzb", :create => true

  #sabnzbdpluss
  config.vm.define :sabnzb do |sabnzb|
    sabnzb.vm.provision :shell, :path => "sabnzb.sh"
    sabnzb.vm.forward_port 8080, 8080
    sabnzb.vm.host_name = "sabnzb"
    sabnzb.vm.network :hostonly, "192.168.2.101"
    
    sabnzb.vm.share_folder "tv", "/media/video/TV", "/media/truecrypt8/Media/TV", :nfs => true
  end

  #Sickbeard server, config files
  config.vm.define :sickbeard do |sickbeard|
    sickbeard.vm.provision :shell, :path => "sickbeard.sh"
    sickbeard.vm.forward_port 8081, 8081
    sickbeard.vm.host_name = "sickbeard"
    sickbeard.vm.network :hostonly, "192.168.2.102"
    #Path to tvshow folder, you can use any mapping here or remove it but sickbeard is setup per default to use /media/video/TV
    sickbeard.vm.share_folder "tv", "/media/video/TV", "Videos/TV", :nfs => true
  end

  #Couchpotato server, config files
  config.vm.define :couchpotato do |couchpotato|
    couchpotato.vm.provision :shell, :path => "couchpotato.sh"
    couchpotato.vm.forward_port 5050, 5050
    couchpotato.vm.host_name = "couchpotato"
    couchpotato.vm.network :hostonly, "192.168.2.103"
    couchpotato.vm.share_folder "movies", "/media/video/Movies", "Videos/Movies", :create => true
  end

  #Headphones server, config files
  config.vm.define :headphones do |headphones|
    headphones.vm.provision :shell, :path => "headphones.sh"
    headphones.vm.forward_port 8181, 8181
    headphones.vm.host_name = "headphones"
    headphones.vm.network :hostonly, "192.168.2.104"
    headphones.vm.share_folder "music", "/media/Music", "Music", :create => true
  end

  #Custom newznab server nZEDb
  config.vm.define :nzedb do |nzedb|
    nzedb.vm.provision :shell, :path => "nzedb.sh"
    nzedb.vm.forward_port 80, 10080
    nzedb.vm.host_name = "nzedb"
    nzedb.vm.network :hostonly, "192.168.2.105"
  end

  #Mediatomb
  #http://mediatomb.cc/
  config.vm.define :mediatomb do |mediatomb|
    mediatomb.vm.provision :shell, :path => "mediatomb.sh"
    #mediatomb.vm.forward_port 58050, 58050
    #mediatomb.vm.forward_port 58051, 58051
    mediatomb.vm.host_name = "mediatomb"
    mediatomb.vm.network :hostonly, "192.168.2.106"
  end

end

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
   #Set to true to debug boot issues if you are in an X environment
   v.gui = false
  end
end
