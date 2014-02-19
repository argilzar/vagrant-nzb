vagrant-nzb
===========
vagrant-nzb is a tool that can help you setup [Virtualbox](https://www.virtualbox.org/wiki/Downloads) boxes for the most popular usenet media tools. The goal of the project is to minimize the hassle it can be to set them all up individually and also to make them portable. The first version of the tool can to some extend manage this for [SabNZBd](http://sabnzbd.org/), [Sickbeard](http://sickbeard.com/), [Couchpotato](https://couchpota.to/), [nzedb](https://github.com/nZEDb/nZEDb). Although this project is aimed at using usenet for downloads you can use torrents or some other method instead.

### Requirements
You need [Virtualbox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://www.vagrantup.com/)

### Quickstart
Use this method if you are not changing any of the default options.

```
$ git clone https://github.com/argilzar/vagrant-nzb.git
$ cd vagrant-nzb
$ vagrant up
```
Vagrant will create the boxes spin them up. The first time it runs it may take some time as the [default box image](http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box) needs to be downloaded. You can then open up the services in a browser

* [Sabnzb](http://localhost:8080/)
* [Sickbeard](http://localhost:8081/)
* [Couchpotato](http://localhost:5050/)
* [Headphones](http://localhost:8181/)

You will need to do some config once the services have started. For SabNZB run the wizzard. The sickbeard and headphones config will be partly updated with sabnzb info.

### Options
Edit default options in vagrant-config.rb or if you are using seperate VMs for each service then also edit config.sh and in.

See also http://argilzar.github.io/vagrant-nzb/
