FROM alpine:3.10

LABEL maintainer="Codam 42 jevan-de@student.codam.nl"

ARG FTP_USER=ftpuser
ARG FTP_USER_PASSWORD=ftppassword
ARG PASV_MIN=21100
ARG PASV_MAX=21102

ENV PASV_ADDRESS=192.168.2.16

# install vsftpd and openssl
RUN apk update \
	&& apk add --no-cache \
		vsftpd \
		openssl \
		vim \
		dos2unix

# overwrite vsftpd config file
ADD config/vsftpd.conf /etc/vsftpd/vsftpd.conf
ADD config/ftps-run.sh /ftps-run.sh

# create a self-signed certificate for vsftp to use to support FTPS
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-subj '/C=NL/ST=NH/L=Amsterdam/O=42/CN=jevan-de' \
		-keyout /etc/ssl/certs/vsftpd.key \
		-out /etc/ssl/certs/vsftpd.crt

# configure vsftpd and create ftp user
RUN echo "pasv_max_port=${PASV_MAX}" >> /etc/vsftpd/vsftpd.conf \
	&& echo "pasv_min_port=${PASV_MIN}" >> /etc/vsftpd/vsftpd.conf \
	&& adduser --disabled-password ${FTP_USER} \
	&& echo "${FTP_USER}:${FTP_USER_PASSWORD}" | chpasswd \
	&& dos2unix /etc/vsftpd/vsftpd.conf /ftps-run.sh \
	&& chmod +x /ftps-run.sh

ENTRYPOINT ["sh", "/ftps-run.sh"]

EXPOSE 21 20 ${PASV_MIN}-${PASV_MAX}
