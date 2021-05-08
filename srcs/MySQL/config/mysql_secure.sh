#/bin/sh

DB_ROOT_PASSWORD_OLD='' 
DB_ROOT_PASSWORD_NEW="${1}"

SECURE_MYSQL=$(expect -c "
	set timeout 3
	spawn mysql_secure_installation

	expect \"Enter current password for root (enter for none):\"
	send \"$DB_ROOT_PASSWORD_OLD\r\"

	expect \"root password?\"
	send \"y\r\"

	expect \"New password:\"
	send \"$DB_ROOT_PASSWORD_NEW\r\"

	expect \"Re-enter new password:\"
	send \"$DB_ROOT_PASSWORD_NEW\r\"

	expect \"Remove anonymous users?\"
	send \"y\r\"

	expect \"Disallow root login remotely?\"
	send \"y\r\"

	expect \"Remove test database and access to it?\"
	send \"y\r\"

	expect \"Reload privilege tables now?\"
	send \"y\r\"

	expect eof
")


echo "${SECURE_MYSQL}"
