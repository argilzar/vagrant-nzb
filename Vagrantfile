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

if !File.exist?('./vagrant-config.rb')
   FileUtils.cp('./vagrant-config-sample.rb', './vagrant-config.rb')
end 

require './vagrant-config'

Vagrant.configure("2") do |config|
  #The ubuntu cloud image, will be downloaded for the first box
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.box = "raring-amd64-vagrant"
  
  config.vm.synced_folder CONFIG_PATH, VM_CONFIG_PATH, :create => true
  config.vm.synced_folder TV_PATH, VM_TV_PATH,:create => true
  config.vm.synced_folder MOVIES_PATH, VM_MOVIES_PATH, :create => true
  config.vm.synced_folder MUSIC_PATH, VM_MUSIC_PATH, :create => true
  

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
          "config_path" => CONFIG_PATH, 
          "vm_config_path" => VM_CONFIG_PATH,
          "tv_path" => TV_PATH, 
          "vm_tv_path" => VM_TV_PATH,
          "movies_path" => MOVIES_PATH,
          "vm_movies_path" => VM_MOVIES_PATH,
          "music_path" => MUSIC_PATH,
          "vm_music_path" => VM_MUSIC_PATH
         }
      end
      combined.vm.provider "virtualbox" do |v|
        v.memory = VM_MEMORY
        v.gui = VM_GUI
        v.customize ["modifyvm", :id, "--cpus", VM_CPU_COUNT]
        if VM_EXEC_CAP > 0
          v.customize ["modifyvm", :id, "--cpuexecutioncap", VM_EXEC_CAP]
        end
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
      nzedb.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/trusty-server-cloudimg-amd64-juju-vagrant-disk1.box"
      nzedb.vm.box = "trusty-amd64-vagrant"     
      nzedb.vm.network "forwarded_port", guest: 80, host: 10080
      #nzedb.vm.network :hostonly, "192.168.2.110"
      nzedb.vm.host_name = "nzedb"
      nzedb.vm.provision :shell, :path => "nzedb.sh"
      nzedb.vm.provider "virtualbox" do |v|
        v.memory = NZEDB_VM_MEMORY
        v.gui = NZEDB_VM_GUI
        v.customize ["modifyvm", :id, "--cpus", NZEDB_VM_CPU_COUNT]
        if NZEDB_VM_EXEC_CAP > 0
          v.customize ["modifyvm", :id, "--cpuexecutioncap", NZEDB_VM_EXEC_CAP]
        end
      end
    end



    #config.vm.define :nzedb do |nzedb|
    #  nzedb.vm.provision :shell, :path => "nzedb.sh"
    #  nzedb.vm.network "forwarded_port", guest: 80, host: 10080
    #  nzedb.vm.host_name = "nzedb"
    #  nzedb.vm.network :hostonly, "192.168.2.105"
    #end
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


