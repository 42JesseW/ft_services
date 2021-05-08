#!/bin/sh

NGINX_CONF_PATH=/etc/nginx/conf.d

# make sure the right IP is set for nginx conf
if [ -f ${NGINX_CONF_PATH}/default.conf ]; then

	# replace server_name lines to make sure redirects are correct
	sed -i "5 s/^.*$/\tserver_name     $MINIKUBE_IP;/" ${NGINX_CONF_PATH}/default.conf;
	sed -i "24 s/^.*$/\tserver_name     $MINIKUBE_IP;/" ${NGINX_CONF_PATH}/default.conf;
	sed -i "28 s/^.*$/\t\treturn 307 http:\/\/$MINIKUBE_IP:5050;/" ${NGINX_CONF_PATH}/default.conf;
fi

# entrypoint command
exec supervisord -c /etc/supervisord.conf
