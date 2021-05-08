FROM alpine:3.10

LABEL maintainer="Codam 42 jevan-de@student.codam.nl"

ARG DB_USER=admin
ARG DB_USER_PASSWORD=password
ARG BLOWFISH_SECRET=\$2a\$07\$EJooQ7FWQIpYWJAMqd0mq.eRnrTTAkqpIwEv1InrJ8q0KMfAK0WLi

ENV DB_USER=${DB_USER}
ENV DB_USER_PASSWORD=${DB_USER_PASSWORD}

# Installing nginx and php-fpm7
RUN apk update \
	&& apk add --no-cache \
		php7-fpm \
		php7-mcrypt php7-soap \
		php7-openssl php7-gmp \
		php7-pdo_odbc php7-json \
		php7-dom php7-pdo php7-zip \
		php7-mysqli php7-sqlite3 \
		php7-apcu php7-pdo_pgsql \
		php7-bcmath php7-gd \
		php7-odbc php7-pdo_mysql \
		php7-pdo_sqlite php7-gettext \
		php7-xmlreader php7-xmlrpc \
		php7-bz2 php7-iconv \
		php7-pdo_dblib php7-curl \
		php7-ctype nginx \
		supervisor \
		dos2unix \
		vim

# configure nginx
RUN adduser -D -g 'www' www \
	&& mkdir /www \
	&& mkdir /run/nginx \
	&& chown -R www:www /var/lib/nginx \
	&& chown -R www:www /www

# overwrite default conf.d
ADD config/default.conf /etc/nginx/conf.d/default.conf

# overwrite default supervisord.conf
ADD config/supervisord.conf /etc/supervisord.conf

WORKDIR /www

# install phpmyadmin
RUN apk add --no-cache \
		mariadb-client \
		php7-session php7-common \
		php7-imap php7-cgi fcgi \
		php7-posix php7-ldap \
		php7-mbstring \
	&& wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz \
	&& tar xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz \
	&& mv phpMyAdmin-4.9.0.1-all-languages/* . \
	&& rm -rf phpMyAdmin-4.9.0.1-all-languages phpMyAdmin-4.9.0.1-all-languages.tar.gz \
	&& echo -e "[mysql]\nuser = ${DB_USER}\npassword = ${DB_USER_PASSWORD}\n" > ~/.my.cnf

# add pma configuration file
ADD config/config.inc.php /www/config.inc.php
ADD config/pma-run.sh /pma-run.sh

# modify config file
# TODO $cfg['PmaAbsoluteUri']
RUN sed -i "s/default_username/${DB_USER}/" config.inc.php \
	&& sed -i "s/default_password/${DB_USER_PASSWORD}/" config.inc.php \
	&& chmod +x /pma-run.sh \
	&& dos2unix /pma-run.sh /etc/supervisord.conf

ENTRYPOINT ["sh", "/pma-run.sh"]
