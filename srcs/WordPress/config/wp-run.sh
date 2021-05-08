#/bin/bash

MYSQL_HOST=mysql-service
EXTERNAL_IP=$MINIKUBE_IP
WORKDIR=/www

mysqladmin --connect-timeout=10 --host=${MYSQL_HOST} -u ${DB_USER} --password=${DB_USER_PASSWORD} status

if [ $? == 0 ]; then
	if [ ! -f "${WORKDIR}/wp-config.php" ]; then
		(cd ${WORKDIR} && wp core config \
			--allow-root \
			--dbname=wordpress \
			--dbuser=${DB_USER} \
			--dbpass=${DB_USER_PASSWORD} \
			--dbhost=${MYSQL_HOST} \
			--dbprefix=wp_)
	fi
	if [ $(mysqlshow -h ${MYSQL_HOST} --protocol=tcp -u ${DB_USER} --password=${DB_USER_PASSWORD} | grep -cw wordpress) == 0 ]; then
		(cd ${WORKDIR} && wp db create \
			--dbuser=${DB_USER} \
			--dbpass=${DB_USER_PASSWORD} \
		&& wp core install \
			--allow-root \
			--url=http://${EXTERNAL_IP}:5050 \
			--title=JesseW \
			--admin_user=${WP_USER} \
			--admin_password=${WP_USER_PASSWORD} \
			--admin_email=${WP_USER_EMAIL} \
		&& wp user create \
			barry \
			barry@kube.net \
			--role=administrator \
			--user_pass=barrypass\
		&& wp user create \
			harry \
			harry@kube.net \
			--role=editor \
			--user_pass=harrypass \
		&& wp user create \
			larry \
			larry@kube.net \
			--role=author \
			--user_pass=larrypass \
		&& wp user create \
			gary \
			gary@kube.net \
			--role=contributor \
			--user_pass=garypass)
	fi
	if [ $(grep -c "WPSITEURL\|WPHOME" ${WORKDIR}/wp-config.php) != 2 ]; then
		sed -i "67idefine( 'WP_SITEURL', 'http://${EXTERNAL_IP}:5050' );" ${WORKDIR}/wp-config.php
		sed -i "68idefine( 'WP_HOME', 'http://${EXTERNAL_IP}:5050' );" ${WORKDIR}/wp-config.php
	fi
	echo "wp cli install script has been run successfully";
else
	echo "[Error] Could not reach mysql-service"
fi

# entrypoint command
exec supervisord -c /etc/supervisord.conf