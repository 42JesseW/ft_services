#!/bin/sh

# make sure pasv_address has correct minikube ip address
if ! grep -q "pasv_address" /etc/vsftpd/vsftpd.conf; then
	echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd/vsftpd.conf
else
	sed -i "149 s/^.*$/pasv_address=${PASV_ADDRESS}/" /etc/vsftpd/vsftpd.conf
fi

exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf