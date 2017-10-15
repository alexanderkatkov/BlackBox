# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.8.0"
VAGRANTFILE_API_VERSION = "2"

# Require YAML module
require 'yaml'

# Read YAML file with box configuration
vmconfig = YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml'))
hosts = []
hosts = vmconfig['hosts']
# Caching hosts for hostupdater if hosts are not empty
if Array(hosts).length != 0
  hostupdater_hosts = []
  hosts.each do |host|
    hostupdater_hosts << host['url']
  end
end

Vagrant.configure("2") do |config|
  # Latest Ubuntu 16.04.3 LTS Box
  config.vm.box = "ubuntu/trusty64"

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
  # Forwarding port for MailHog admin
  config.vm.network "forwarded_port", guest: 8025, host: 8025

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./apps", "/var/www", id: "vagrant-root",
    owner: "vagrant",
    group: "www-data",
    mount_options: ["dmode=775,fmode=664"]

  config.vm.synced_folder "./log", "/var/log", id: "server-logs",
    owner: "vagrant",
    group: "www-data",
    mount_options: ["dmode=775,fmode=664"]

  # Optional NFS. Make sure to remove other synced_folder line too
  # config.vm.synced_folder ".", "/var/www", :nfs => { :mount_options => ["dmode=777","fmode=666"] }

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
  mysql_root_pw = vmconfig["mysql_root_pw"]

  # -----------------------------------------------------------
  # BASE
  # -----------------------------------------------------------
  config.vm.provision :shell, path: "scripts/update.sh"
  config.vm.provision :shell, path: "scripts/base.sh"
  # -----------------------------------------------------------
  # SERVER
  # -----------------------------------------------------------
  config.vm.provision :shell, path: "scripts/server/apache2.sh"
  config.vm.provision :shell, path: "scripts/server/php.sh"
  # config.vm.provision :shell, path: "scripts/server/nodejs.sh", privileged: false
  # -----------------------------------------------------------
  # DATABASE
  # -----------------------------------------------------------
  # config.vm.provision :shell, path: "scripts/database/mysql.sh", :args => [mysql_root_pw]
  # config.vm.provision :shell, path: "scripts/database/sqlite.sh"
  # -----------------------------------------------------------
  # TOOLS
  # -----------------------------------------------------------
  # config.vm.provision :shell, path: "scripts/tools/ruby.sh"
  # config.vm.provision :shell, path: "scripts/tools/composer.sh"
  # config.vm.provision :shell, path: "scripts/tools/wp-cli.sh"
  # config.vm.provision :shell, path: "scripts/tools/mailhog.sh", privileged: false
  # -----------------------------------------------------------
  # VHOSTS
  # -----------------------------------------------------------
  # Creating & configuring VHOSTS for Apache2 if not empty hosts array
  if Array(hosts).length != 0
    hosts.each do |host|
      url = host['url']
      path = host['path']
      config.vm.provision :shell, path: "scripts/vhosts/vhost_create.sh", :args => [url, path]
      config.vm.provision :shell, path: "scripts/vhosts/vhost_enable.sh", :args => [url]
    end
  end
end
