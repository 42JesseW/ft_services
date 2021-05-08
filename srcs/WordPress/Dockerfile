FROM alpine:3.10

LABEL maintainer="Codam 42 jevan-de@student.codam.nl"

ARG DB_USER=admin
ARG DB_USER_PASSWORD=password
ARG WP_USER=wpadmin
ARG WP_USER_PASSWORD=wppassword
ARG WP_USER_EMAIL=jevan-de@student.codam.nl

ENV DB_USER=${DB_USER}
ENV DB_USER_PASSWORD=${DB_USER_PASSWORD}
ENV WP_USER=${WP_USER}
ENV WP_USER_PASSWORD=${WP_USER_PASSWORD}
ENV WP_USER_EMAIL=${WP_USER_EMAIL}

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
		bash \
		dos2unix \
		supervisor \
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

# install wordpress
RUN apk add --no-cache \
		php7 \
		php7-phar \
		mariadb-client \
	&& wget http://wordpress.org/latest.tar.gz \
	&& tar -xzf latest.tar.gz \
	&& rm latest.tar.gz \
	&& mv wordpress/* . \
	&& rm -rf wordpress \
	&& wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

ADD config/wp-run.sh /wp-run.sh

# make sure wp-run is executable
# make sure wp-run is readable in linux
# sendmail requires a FQDN in /etc/hosts
RUN chmod +x /wp-run.sh \
	&& dos2unix /wp-run.sh /etc/supervisord.conf \
	&& echo "$(hostname -i)	$(hostname) $(hostname).localhost" >> /etc/hosts

ENTRYPOINT ["sh", "/wp-run.sh"]
