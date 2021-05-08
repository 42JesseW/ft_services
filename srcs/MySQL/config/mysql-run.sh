#!/bin/bh

# make sure mysql socket can be created
if [ ! -d /run/mysqld ]; then
	mkdir -p /run/mysqld
	chown mysql:mysql /run/mysqld
fi

# check if first run
if [ ! -d /var/lib/mysql/mysql ]; then

	# install mysql
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

	# initialise mysql database for cluster
	# - create remote user with '{user}'@'%'
	# - make sure bind-address = 0.0.0.0
	# - make sure skip-networking = false
	mysqld_safe --user=mysql --no-watch	
	sleep 2
	mysql --verbose -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';"
	mysql --verbose -e "CREATE DATABASE phpmyadmin;"
	mysql --verbose -e "GRANT ALL PRIVILEGES ON phpmyadmin.* TO '${DB_USER}'@'%';"
	mysql --verbose -e "GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';"
	
	# secure mysql using expect
	/bin/sh /mysql_secure.sh ${DB_ROOT_PASSOWRD}
	mysqladmin -u root --password=${DB_ROOT_PASSOWRD} shutdown
fi

exec mysqld_safe --user=mysql --console
