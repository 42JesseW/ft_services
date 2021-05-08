#/bin/bash

set -xe

minikube delete
minikube start --driver=virtualbox --memory=3000MB --bootstrapper=kubeadm
minikube addons enable metallb

# 							METALLB
# [Check if running] minikube kubectl -- get pods -n metallb-system

# install metallb by manifest https://metallb.universe.tf/installation/
minikube kubectl -- apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
minikube kubectl -- apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml

# get minikube IP and set it in environment
MINIKUBE_IP=$(minikube ip)
kubectl create secret generic minikube-ip --from-literal=ip=$MINIKUBE_IP

# make sure that the images are build within docker for minikube
eval $(minikube docker-env --shell=zsh)

# The memberlist secret contains the secretkey to encrypt the communication between speakers for the fast dead node detection.
minikube kubectl -- create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

# metallb must use the right address pool
sed -i "" "12 s/^.*$/      - $MINIKUBE_IP-$MINIKUBE_IP/" srcs/metallb.yaml

# create config so MetalLB's component will not remain idle
kubectl apply -f srcs/metallb.yaml

#							MySQL
docker build -t ft-services-mysql srcs/MySQL
kubectl apply -f srcs/MySQL/mysql.yaml

#							PhpMyAdmin
docker build -t ft-services-phpmyadmin srcs/PhpMyAdmin
kubectl apply -f srcs/PhpMyAdmin/phpmyadmin.yaml

#							Wordpress
docker build -t ft-services-wordpress srcs/WordPress
kubectl apply -f srcs/WordPress/wordpress.yaml

#							NGINX
docker build -t ft-services-nginx srcs/Nginx
kubectl apply -f srcs/Nginx/nginx.yaml

#							FTPS
docker build -t ft-services-ftps srcs/FTPS
kubectl apply -f srcs/FTPS/ftps.yaml

#							InfluxDB
docker build -t ft-services-influxdb srcs/InfluxDB
kubectl apply -f srcs/InfluxDB/influxdb.yaml

#							Telegraf
docker build -t ft-services-telegraf srcs/Telegraf
kubectl apply -f srcs/Telegraf/telegraf.yaml

# create ConfigMap holding provisioning files for grafana
kubectl create configmap grafana-provisioning \
	--from-file=datasource.yaml=srcs/grafana/config/datasource.yaml \
	--from-file=dashboards.yaml=srcs/grafana/config/dashboards.yaml \
	--from-file=dashboard-ftps.json=srcs/grafana/config/dashboards/dashboard-ftps.json \
	--from-file=dashboard-grafana.json=srcs/grafana/config/dashboards/dashboard-grafana.json \
	--from-file=dashboard-influxdb.json=srcs/grafana/config/dashboards/dashboard-influxdb.json \
	--from-file=dashboard-mysql.json=srcs/grafana/config/dashboards/dashboard-mysql.json \
	--from-file=dashboard-nginx.json=srcs/grafana/config/dashboards/dashboard-nginx.json \
	--from-file=dashboard-phpmyadmin.json=srcs/grafana/config/dashboards/dashboard-phpmyadmin.json \
	--from-file=dashboard-telegraf.json=srcs/grafana/config/dashboards/dashboard-telegraf.json \
	--from-file=dashboard-wordpress.json=srcs/grafana/config/dashboards/dashboard-wordpress.json

#							Grafana
docker build -t ft-services-grafana srcs/grafana
kubectl apply -f srcs/grafana/grafana.yaml

