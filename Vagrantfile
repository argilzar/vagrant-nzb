# -*- mode: ruby -*-
# vi: set ft=ruby :
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
#Set to false those services you dont need
USE_NZEDB=false
USE_MEDIATOMB=false
#These can be combined into one box
USE_SABNZBD=true
USE_SICKBEARD=true
USE_COUCHPOTATO=true
USE_HEADPHONES=true

#Combine sabnzb,sickbeard,couchpotato and headephones into one box
#Note you still need to activate each service you need, default is all enabled
USE_COMBINED=true

Vagrant.configure("2") do |config|
  #The ubuntu cloud image, will be downloaded for the first box
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.box = "raring-amd64-vagrant"
  
  #Default location for all the setting files, incomplete downloads and cache
  #You can not omit this unless you change the defaults in the provisioning scripts
  #The mount point should be /mnt/nzb always
  #If you do not change this then nzb folder will be created in current dir
  config.vm.synced_folder "nzb", "/mnt/nzb", :create => true
  #Path to tvshow folder, you can use any mapping here or remove it but sickbeard is setup per default to use /media/video/TV
  config.vm.synced_folder "Videos/TV", "/media/video/TV",:create => true
  config.vm.synced_folder "Videos/Movies", "/media/video/Movies", :create => true
  config.vm.synced_folder "Music", "/media/Music", :create => true
  

  if USE_COMBINED
    config.vm.define :combined do |combined|
      combined.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
      combined.vm.box = "trusty-amd64-vagrant"      
      combined.vm.network "forwarded_port", guest: 8080, host: 8080
      combined.vm.network "forwarded_port", guest: 8081, host: 8081
      combined.vm.network "forwarded_port", guest: 5050, host: 5050
      combined.vm.network "forwarded_port", guest: 8181, host: 8181
      #combined.vm.network :hostonly, "192.168.2.110"
      combined.vm.host_name = "combined"
      combined.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file  = "site.pp"
        puppet.facter = { 
          "fqdn" => "combined.localhost", 
          "hostname" => "combined", 
          "use_sabnzbd" => USE_SABNZBD,
          "use_sickbeard" => USE_SICKBEARD,
          "use_couchpotato" => USE_COUCHPOTATO,
          "use_headphones" => USE_HEADPHONES,
         }
      end
    end 
  else
    #sabnzbdpluss
      if USE_SABNZBD
       config.vm.define :sabnzb do |sabnzb|
         sabnzb.vm.provision :shell, :path => "sabnzb.sh"
         sabnzb.vm.forward_port 8080, 8080
         sabnzb.vm.host_name = "sabnzb"
         sabnzb.vm.network :hostonly, "192.168.2.101"
       end
      end

      #Sickbeard server, config files
      if USE_SICKBEARD
        config.vm.define :sickbeard do |sickbeard|
          sickbeard.vm.provision :shell, :path => "sickbeard.sh"
          sickbeard.vm.network "forwarded_port", guest: 8081, host: 8081
          sickbeard.vm.host_name = "sickbeard"
          sickbeard.vm.network :hostonly, "192.168.2.102"
        end
      end

      #Couchpotato server, config files
      if USE_COUCHPOTATO
        config.vm.define :couchpotato do |couchpotato|
          couchpotato.vm.provision :shell, :path => "couchpotato.sh"
          couchpotato.vm.network "forwarded_port", guest: 5050, host: 5050
          couchpotato.vm.host_name = "couchpotato"
          couchpotato.vm.network :hostonly, "192.168.2.103"
        end
      end

      #Headphones server, config files
      if USE_HEADPHONES
        config.vm.define :headphones do |headphones|
          headphones.vm.provision :shell, :path => "headphones.sh"
          headphones.vm.network "forwarded_port", guest: 8181, host: 8181
          headphones.vm.host_name = "headphones"
          headphones.vm.network :hostonly, "192.168.2.104"
        end
      end
  end  
  
  #Custom newznab server nZEDb
  if USE_NZEDB
    config.vm.define :nzedb do |nzedb|
      nzedb.vm.provision :shell, :path => "nzedb.sh"
      nzedb.vm.network "forwarded_port", guest: 80, host: 10080
      nzedb.vm.host_name = "nzedb"
      nzedb.vm.network :hostonly, "192.168.2.105"
    end
  end

  #Mediatomb
  #http://mediatomb.cc/
  if USE_MEDIATOMB
    config.vm.define :mediatomb do |mediatomb|
      mediatomb.vm.provision :shell, :path => "mediatomb.sh"
      #mediatomb.vm.forward_port 58050, 58050
      #mediatomb.vm.forward_port 58051, 58051
      mediatomb.vm.host_name = "mediatomb"
      mediatomb.vm.network :hostonly, "192.168.2.106"
    end
  end

end


