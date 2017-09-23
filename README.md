# BlackBox v2.0.2

Vagrant LAMP stack provision script, based on [LTS trusty/ubuntu-14.04](https://app.vagrantup.com/ubuntu/boxes/trusty64).
Supports multiply virtual hosts & host directory configuration.

## Included packages
	01. Apache2
	02. PHP 7.0 with xDebug
	03. MySQL 5.7 Server & Client
	04. Redis
	05. SQLite3
	06. Ruby & Ruby Dev
	07. Git
	08. Composer
	09. Mailhog for Web and API based SMTP testing
	10. WP CLI
	11. Node.js 7.x
	12. Gulp
	13. Bower

## Installation process

- Install [VirtualBox](https://www.virtualbox.org/)
- Install [Vagrant](https://www.vagrantup.com/)
- Clone **BlackBox** repository `git clone https://github.com/alexanderkatkov/blackbox.git path_to_project_folder`
- Set box **Domain** & **IP** in config.yml
- Set additional **virtual hosts** in config.yml if needed
- Run `vagrant up` in console

## Configuration & Usage

### How to Create Additional Virtual Hosts
Open File **config.yml** in editor. Add additional vhosts in hosts section as listed below.

```yaml
# List of virtual hosts
hosts:
  -
    url: host1.app
    path: '/'
  -
    url: host2.app
    path: public
  -
    url: host3.app
    path: public
```

### Connecting to MySQL database from the
No PhpMyAdmin is installed inside guest machine, so you can manage you databases from outside using MySQL Workbench, Navicat or similar.

Default username & password - **root**

#### Settings
* Connection Method: Standard TCP/IP over SSH
* SSH Hostname: 127.0.0.1:2222
* Username: vagrant
* SSH key file: {Path to project}\\.vagrant\machines\default\virtualbox\private_key
* MySQL Hostname: 127.0.0.1
* MySQL Server Port: 3306
* Username: root
* Password: root

### xDebug settings

* IDE Key: XDEBUG
* Protocol: DBGp

### MailHog Access
To see emails catched by MailHog go to URL: **{box-ip}:8025**
