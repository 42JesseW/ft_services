FROM alpine:3.10

LABEL maintainer="Codam 42 jevan-de@student.codam.nl"

ARG DB_USER=admin
ARG DB_USER_PASSWORD=password
ARG DB_ROOT_PASSOWRD=rootpassword

ENV DB_USER=${DB_USER}
ENV DB_USER_PASSWORD=${DB_USER_PASSWORD}
ENV DB_ROOT_PASSOWRD=${DB_ROOT_PASSOWRD}

# install required packages
RUN apk update \
	&& apk add --no-cache \
		mariadb \
		mariadb-common \
		mariadb-client \
		expect \
		dos2unix \
		vim

# move required config files
ADD config/mysql_secure.sh /mysql_secure.sh
ADD config/my.cnf /etc/my.cnf
ADD config/mysql-run.sh /mysql-run.sh

# set config file permissions
RUN chmod +x /mysql_secure.sh \
	&& dos2unix /mysql_secure.sh \
	&& chmod +x /mysql-run.sh \
	&& dos2unix /mysql-run.sh

ENTRYPOINT ["sh", "/mysql-run.sh"]

EXPOSE 3306
