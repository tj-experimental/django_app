#!/usr/bin/env bash

# Add the student user 
if [ ! `id -u student 2>/dev/null || echo -1` -ge 0 ]; then
	sudo su
	sudo adduser student 
	sudo echo "student ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/student
fi 	

sudo -su student

# ufw setup
sudo ufw default deny incoming 
sudo ufw default allow outgoing 
sudo ufw allow ssh
sudo ufw allow 2222/tcp
sudo ufw allow www

if [ ! -f /var/log/apache2/tdd-error.log ]; then
	echo "Creating tdd-error.log"
	touch /var/log/apache2/tdd-error.log
fi

if [ ! -f /var/log/apache2/tdd-access.log ]; then
	echo "Creating tdd-access.log"
	touch /var/log/apache2/tdd-access.log
fi

DATABASE_NAMES=( "superlists" "superlist_test" "superlist_template" "superlist_stage" )

for DATABASE_NAME in "${DATABASE_NAMES[@]}"
do
	echo "Checking for databsae $DATABASE_NAME."
	sudo -u postgres psql -d postgres -t -c "Select datname from pg_database where datistemplate = 'f'::bool AND datname = '$DATABASE_NAME';" || 
	echo "Creating database $DATABASE_NAME" && sudo -u postgres psql -d postgres -c "CREATE DATABASE $DATABASE_NAME;" 2>/dev/null
done

create_test_user(){
	echo "Creating test user..."
   	sudo -u postgres psql -d postgres -f "/home/vagrant/create_test_user.sql"
}

# Check for test user
sudo -u postgres psql -d postgres -t -c "\du" | cut -d \| -f 1 | grep -qw "test_user" || create_test_user

sudo mv "/home/vagrant/tdd_django.conf" /etc/apache2/sites-available
sudo chown student:student /etc/apache2/sites-available/tdd_django.conf