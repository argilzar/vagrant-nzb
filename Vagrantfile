# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
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
  end

  #Sickbeard server, config files
  config.vm.define :sickbeard do |sickbeard|
    sickbeard.vm.provision :shell, :path => "sickbeard.sh"
    sickbeard.vm.forward_port 8081, 8081
    sickbeard.vm.host_name = "sickbeard"
    sickbeard.vm.network :hostonly, "192.168.2.102"
    #Path to tvshow folder, you can use any mapping here or remove it but sickbeard is setup per default to use /media/video/TV
    sickbeard.vm.share_folder "tv", "/media/video/TV", "Videos/TV", :create => true
  end

  #Couchpotato server, config files
  config.vm.define :couchpotato do |couchpotato|
    couchpotato.vm.provision :shell, :path => "couchpotato.sh"
    couchpotato.vm.forward_port 5050, 5050
    couchpotato.vm.host_name = "couchpotato"
    couchpotato.vm.network :hostonly, "192.168.2.103"
    couchpotato.vm.share_folder "movies", "/media/video/Movies", "Videos/Movies", :create => true
  end
end
