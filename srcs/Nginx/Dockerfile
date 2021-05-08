# TODO check if openssh server is still running after restart

FROM alpine:3.10

LABEL maintainer="Codam 42 jevan-de@student.codam.nl"

ARG SSH_USER=sshuser
ARG SSH_USER_PASSWORD=sshuserpassword

ENV MINIKUBE_IP=192.168.2.16

# Installing nginx and openssl
RUN apk update \
	&& apk add --no-cache \
		openssh \
		openssl \
		nginx \
		supervisor \
		vim \
		dos2unix

# configure nginx
RUN adduser -D -g 'www' www \
	&& mkdir /www \
	&& mkdir /run/nginx \
	&& chown -R nginx:nginx /var/lib/nginx

# create a self-signed certificate for nginx to use to support
# traffic over https, port 443
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-subj '/C=NL/ST=NH/L=Amsterdam/O=42/CN=jevan-de' \
		-keyout /etc/ssl/certs/default.key \
		-out /etc/ssl/certs/default.crt

# overwrite default conf.d
ADD config/default.conf /etc/nginx/conf.d/default.conf

# overwrite default supervisord.conf
ADD config/supervisord.conf /etc/supervisord.conf

# add index files
ADD config/index.html /www/index.html
ADD config/style.css /www/style.css
ADD config/nginx-run.sh /nginx-run.sh

# last nginx configuration changes
RUN chown -R nginx:nginx /www \
	&& chmod +x nginx-run.sh \
	&& dos2unix /nginx-run.sh

# configure openssh and ssh user
RUN ssh-keygen -A \
	&& adduser --disabled-password ${SSH_USER} \
	&& echo "${SSH_USER}:${SSH_USER_PASSWORD}" | chpasswd

WORKDIR /www

ENTRYPOINT ["sh", "/nginx-run.sh"]

EXPOSE 22 80 443
