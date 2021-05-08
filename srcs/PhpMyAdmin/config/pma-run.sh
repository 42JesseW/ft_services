#/bin/sh

mysqladmin --connect-timeout=10 --host=mysql-service -u ${DB_USER} --password=${DB_USER_PASSWORD} status

if [ $? == 0 ]; then
	# If database phpmyadmin exists, create tables for phpmyadmin
	if [ $(mysqlshow -h mysql-service --protocol=tcp -u ${DB_USER} --password=${DB_USER_PASSWORD} | grep -cw phpmyadmin) ]; then
		mysql -h mysql-service --protocol=tcp -u ${DB_USER} --password=${DB_USER_PASSWORD} < /www/sql/create_tables.sql;
		echo "create_tables.sql script has been run successfully";
	fi
fi

# entrypoint command
exec supervisord -c /etc/supervisord.conf
