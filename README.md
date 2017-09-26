# TDD Django project #

 Using a TDD approach in designing and deploying a django project based on TDD with python.
 
 
### Quick Summary 
 Built with django microframework also using mod_wsgi with apache http server for deployment.
 
 
### Setup
 The project can be run on a virtual machine using vagrant.
 
 1.  Download a Virtual box 
 2.  Download Vagrant 
 
#### Create `Vagrantfile` using a preferred Linux distribution 
 1. vagrant init ubuntu/trusty
 2. vagrant up
 
 Confirm setup with `vagrant status`
 
Configure the Ubuntu defualt firewall config tool `ufw`
```cmd
sudo ufw default deny incoming 
sudo ufw default allow outgoing 
sudo ufw allow ssh
sudo ufw allow 2222/tcp
sudo ufw allow www
```
Enable pulic access to port 8080 

Edit the `Vagrantfile` and uncomment the vm_network or add line 
  `config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"`


Reload VM `vagrant reload`

Setup Apache on Ubuntu run
`sudo apt-get install apache2`

Confirm apache is running 
`sudo apache2ctl status`

Install mod_wsgi for python 3
`sudo apt-get install libapache2-mod-wsgi-py3`

Install python3 and python3-pip
 - `sudo apt-get install python3`
 - `sudo apt-get install python3-pip`

Create log files 
 - `sudo touch /var/log/apache2/tdd-error.log`
 - `sudo touch /var/log/apache2/tdd-access.log`

Add a new apache sites available config or modify the defualt config `/etc/apache2/sites-enabled/`.

If adding a new site available after adding configuration run
`sudo a2ensite new-site.conf`


Add these configuration
```cfg
<VirtualHost *:80>
    ServerName tdd-django
    ServerAdmin jtonye@ymail.com

    WSGIScriptAlias / /path/to/tdd_django/superlists/superlists/wsgi.py
    # If using a virtual env
    WSGIDaemonProcess tdd-django python-path=/path/to/virtualenv/lib/python3.4/site-packages:/path/to/tdd_django/superlists
    WSGIProcessGroup tdd-django

   <Directory /home/student/workspaces/tdd_django/superlists/superlists>
      <Files wsgi.py>
          Require all granted
      </Files>
   </Directory>

   ErrorLog /var/log/apache2/tdd-error.log
   # Possible values include: debug, info, notice, warn, error, crit,
   # alert, emerg.

   LogLevel warn

   CustomLog /var/log/apache2/tdd-access.log combined
</VirtualHost>
```

Install postgresql 
 `sudo apt-get install postgresql`


Run db_script using
  `sudo -u postgres psql -d postgres -f /path/to/tdd_django/db_script.sql`
 

Run django migration `python3 /path/to/tdd_django/superlist/manage.py migrate`


Restart Apache with `sudo apache2ctl restart`


Visit `http://tdd_django.localhost:8080/`

### Contact 
   - Owner: Tonye Jack
   - Email: jtonye@ymail.com
