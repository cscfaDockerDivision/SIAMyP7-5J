#! /bin/bash

apt-get -y install apache2 \
        php mysql-server \
        libapache2-mod-php \
        php-mysql \
        php-intl \
        php-curl \
        php-cli \
        php-gd \
        php-xml \
        acl \
        php-mcrypt \
       	php-soap

echo "ServerName localhost" >> /etc/apache2/apache2.conf

mkdir /var/run/sshd
echo "AllowUsers remote" >> /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config

if [ ! -d /mnt/hostShared ]
then
	mkdir /mnt/hostShared;
fi
if [ -d /var/lib/mysql ]
then
	mv /var/lib/mysql /mnt/hostShared/mysql
else
	mkdir /mnt/hostShared/mysql
	chown mysql:mysql /mnt/hostShared/mysql
	chmod 700 /mnt/hostShared/mysql
fi
if [ ! -d /mnt/hostShared/mysql_backup ]
then
	mkdir /mnt/hostShared/mysql_backup
	chown mysql:mysql /mnt/hostShared/mysql_backup
	chmod 700 /mnt/hostShared/mysql_backup
fi
if [ ! -d /mnt/hostShared/mysql_log ]
then
	mkdir /mnt/hostShared/mysql_log
	chown mysql:mysql /mnt/hostShared/mysql_log
	chmod 700 /mnt/hostShared/mysql_log
	touch /mnt/hostShared/mysql_log/error.log
	chown mysql:mysql /mnt/hostShared/mysql_log/error.log
	chmod 700 /mnt/hostShared/mysql_log/error.log
fi

mv /mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
chmod 644 /etc/mysql/mysql.conf.d/mysqld.cnf

sed -i '/;date.timezone =/c\date.timezone = '\''Europe/Luxembourg'\' /etc/php/7.0/apache2/php.ini
sed -i '/;date.timezone =/c\date.timezone = '\''Europe/Luxembourg'\' /etc/php/7.0/cli/php.ini
sed -i '/memory_limit = 128M/c\memory_limit = 256M' /etc/php/7.0/apache2/php.ini
sed -i '/memory_limit = -1/c\memory_limit = 256M' /etc/php/7.0/cli/php.ini

mkdir /mnt/hostShared/mysql_backup
(crontab -l ; echo "0 */1 * * * mysql -uroot -e 'show databases' | while read dbname; do mysqldump -uroot "\""\$dbname"\"" > /tmp/"\""\$dbname"\"".sql; tar zcvf /mnt/hostShared/mysql_backup/"\""\$dbname"\"".tar.gz /tmp/"\""\$dbname"\"".sql; done") | sort - | uniq - | crontab -
(crontab -l ; echo "0 0 * * */1 mysql -uroot -e 'show databases' | while read dbname; do mysqldump -uroot "\""\$dbname"\"" > /tmp/"\""\$dbname"\"".sql; tar zcvf /mnt/hostShared/mysql_backup/\`date +\"%Y%m%d\"\`_"\""\$dbname"\"".tar.gz /tmp/"\""\$dbname"\"".sql; done") | sort - | uniq - | crontab -
(crontab -l ; echo "0 0 * * */1 find /mnt/hostShared/mysql_backup/*.tar.gz -mtime +7 -exec rm {} \\;") | sort - | uniq - | crontab -

sed -i '/session    required     pam_loginuid.so/c\session    optional     pam_loginuid.so\' /etc/pam.d/sshd

