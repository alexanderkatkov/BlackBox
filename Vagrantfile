# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.8.0"
VAGRANTFILE_API_VERSION = "2"

# Require YAML module
require 'yaml'

# Read YAML file with box configuration
vmconfig = YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml'))
hosts = vmconfig['hosts']
# Caching hosts for hostupdater
hostupdater_hosts = []
hosts.each do |host|
  hostupdater_hosts << host['url']
end

Vagrant.configure("2") do |config|
  # Latest Ubuntu 16.04 LTS Box
  config.vm.box = "bento/ubuntu-16.04"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: vmconfig["ip"]
  # Hostname for main IP
  config.vm.hostname = vmconfig["domain"]
  # Creating virtual hosts with hostupdater
  config.hostsupdater.aliases = hostupdater_hosts

  # Forwarding port for MySQL host connections
  config.vm.network "forwarded_port", guest: 3306, host: 3306

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder ".", "/var/www", :mount_options => ["dmode=777", "fmode=666"]

  # Optional NFS. Make sure to remove other synced_folder line too
  config.vm.synced_folder ".", "/var/www", :nfs => { :mount_options => ["dmode=777","fmode=666"] }

  # Configuration for VirtualBox:
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.memory = vmconfig["memory"]

    # Customize the number of CPUs using by VM
    vb.cpus = vmconfig["cpu"]
  end

	ip = vmconfig["ip"]

  # Intro message
  config.vm.provision :shell, path: "scripts/intro.sh"
	# Update system & packages
  # config.vm.provision :shell, path: "scripts/update.sh"
  # Apache2 provision
  config.vm.provision :shell, path: "scripts/apache2.sh"
	# Server packages installation & configuration
  config.vm.provision :shell, path: "scripts/server-packages.sh", :args => [ip]
	# VHosts provision for Apache2
  config.vm.provision :shell, path: "scripts/hosts.sh"

  # Creating & configuring VHOSTS for Apache2
  hosts.each do |host|
    url = host['url']
    path = host['path']
    config.vm.provision :shell, path: "scripts/hosts.sh", :args => [url, path]
  end

end
