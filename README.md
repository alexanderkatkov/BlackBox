# BlackBox v2.0.0

Vagrant LAMP stack provision script, based on [LTS ubuntu/trusty64](https://app.vagrantup.com/ubuntu/boxes/trusty64).
Supports multiply virtual hosts & host directory configuration.
Projects are stored into the **apps/** folder.

## Included packages

	01. Apache2
	02. PHP 7.1 with xDebug
	03. Node.js 6.11 LTS
	04. MySQL 5.5 Server & Client
	05. SQLite3
	06. Composer
	07. Mailhog for Web and API based SMTP testing
	08. WP CLI
	09. Git
	10. Ruby

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
    path: subpath1/subpath2
  -
    url: host3.app
    path: public
```

### Connecting to MySQL database from the
No PhpMyAdmin is installed inside guest machine, but you can manage you databases from outside using MySQL Workbench, Navicat or similar.

Default MySQL username & password - **root**
MySQL **@root password** can be changed in config.yml

#### Settings for MysQL remote connection
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
* Port: 9000

#### launch.json for VS Code
```json
{
	"name": "XDEBUG",
	"type": "php",
	"request": "launch",
	"port": 9000,
	"localSourceRoot": "${workspaceRoot}/apps/",
	"serverSourceRoot": "/var/www/"
}
```

### MailHog Access
To see emails catched by MailHog go to URL: **{box-ip}:8025**
