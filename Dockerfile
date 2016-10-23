FROM ubuntu:xenial
MAINTAINER Matthieu VALLANCE

ENV DEBIAN_FRONTEND noninteractive

# ---------------------------------------START 1------------------------------------------------
# Installation of the base tools
# for php manual build : 	build-essential
# for package management :	apt-utils, python-software-properties, software-properties-common, npm
# for user management :		sudo
# for download :			wget, git
# for softawre management :	supervisor
# for source management :	subversion
# for remote connectivity :	openssh-server
# for use :					locate, nano, zip, unzip, nodejs, ant, man-db
# for compatibility :		language-pack-en-base
# for administration :		rsyslog
# ----------------------------------------------------------------------------------------------
ADD baseInstall.sh /baseInstall.sh
RUN bash /baseInstall.sh && rm /baseInstall.sh
# --------------------------------------- END 1 ------------------------------------------------



# ---------------------------------------START 2------------------------------------------------
# Download and build of PHP 5.6 version
# Dependencies : 			curl, libcurl3, libcurl3-dev, libjpeg-dev, libpng16-dev, libgcrypt11-dev,
#							zlib1g-dev, libmcrypt-dev, libxml2-dev, pkg-config
# Download location :		/usr/local/src/php5.6.25/php-5.6.25.tar.bz2
# Extraction location : 	/usr/local/src/php5.6.25/php-5.6.25
# Installation location :	/usr/local/php-5.6.25
# Executable location :		/usr/bin/php56
# Configuration :			from production source example
# Date time configuration : Europe/Luxembourg
# Memory limit :			256M
#
# PHP configuration :		with-mysqli, enable-intl, with-curl, with-gd, with-mcrypt,
#							enable-soap, with-zlib, with-pdo-mysql, with-jpeg, with-png
#							enable-opcache, with-openssl
# ----------------------------------------------------------------------------------------------
ADD php56.conf /php56.conf
ADD php5Install.sh /php5Install.sh
RUN bash /php5Install.sh && rm /php5Install.sh && rm /php56.conf
# --------------------------------------- END 2 ------------------------------------------------



# ---------------------------------------START 3------------------------------------------------
# Installation of apache2/PHP7/mysql and configure ssh server
#
# Adding 'localhost' servername to the apache2 configuration
# Set 'remote' user ssh configuration
# Set data dir to /mnt/hostShared/mysql for mysql
# Setting mysql bakup directory to /mnt/hostShared/mysql_backup
# Setting mysql log file to /mnt/hostShared/mysql_log/error.log
# Mysql backup setting :	1 hourly backup of each tables (1 hour life time)
#							1 daily backup of each tables (7 days life time)
#
# Php 7 setting :
# Date time configuration : Europe/Luxembourg
# Memory limit :			256M
# ----------------------------------------------------------------------------------------------
ADD mysqld.cnf /mysqld.cnf
ADD serverInstall.sh /serverInstall.sh
RUN bash /serverInstall.sh && rm /serverInstall.sh
# --------------------------------------- END 3 ------------------------------------------------



# ---------------------------------------START 4------------------------------------------------
# Java installation
#
# Java type :			Non free oracle V8 installation with license
# License accepted version :	accepted-oracle-license-v1-1
# Repository :			webupd8team/java
#
# License acceptance automation activated by debconf
# ----------------------------------------------------------------------------------------------
ADD javaInstall.sh /javaInstall.sh
RUN bash /javaInstall.sh && rm /javaInstall.sh
# --------------------------------------- END 4 ------------------------------------------------



# ---------------------------------------START 5------------------------------------------------
# Installation of Jenkins Integration Server
# Adding repository key and install
#
# Setting jenkins home :			/mnt/hostShared/jenkins
# Setting jenkins log directory : 	/mnt/hostShared/jenkins_logs
# Setting jenkins bakup directory :	/mnt/hostShared/jenkins_backup
# Jenkins backup setting :	1 midnight backup of home per day (1 day life time)
#							1 weekly backup of home (30 days life time)
# ----------------------------------------------------------------------------------------------
ADD jenkinsInstall.sh /jenkinsInstall.sh
RUN bash /jenkinsInstall.sh && rm /jenkinsInstall.sh
# --------------------------------------- END 5 ------------------------------------------------



# ---------------------------------------START 6------------------------------------------------
# Tools installation
#
# Tools : phpunit, phpcs, phpcbf, phpmd, sami, phpcpd, phpdcd, phploc
#
# phpunit installed version :		4.8, 5.6, latest
# phpunit download location :		/usr/local/src/phpunit/4.8/phpunit.phar
#									/usr/local/src/phpunit/5.6/phpunit.phar
#									/usr/local/src/phpunit/latest/phpunit.phar
# phpunit executable location :		/usr/bin/phpunit48
#									/usr/bin/phpunit56
#									/usr/bin/phpunit
# phpcs installed version :			https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
# phpcs download location :			/usr/local/src/phpcs/phpcs.phar
# phpcs executable location :		/usr/bin/phpcs
# phpcbf installed version :		https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar
# phpcbf download location :		/usr/local/src/phpcbf/phpcbf.phar
# phpcbf executable location :		/usr/bin/phpcbf
# phpmd installed version :			http://static.phpmd.org/php/latest/phpmd.phar
# phpmd download location :			/usr/local/src/phpmd/phpmd.phar
# phpmd executable location :		/usr/bin/phpmd
# sami installed version :			http://get.sensiolabs.org/sami.phar
# sami download location :			/usr/local/src/sami/sami.phar
# sami executable location :		/usr/bin/sami
# phpcpd installed version :		https://phar.phpunit.de/phpcpd.phar
# phpcpd download location :		/usr/local/src/phpcpd/phpcpd.phar
# phpcpd executable location :		/usr/bin/phpcpd
# phpdcd installed version :		https://phar.phpunit.de/phpdcd.phar
# phpdcd download location :		/usr/local/src/phpdcd/phpdcd.phar
# phpdcd executable location :		/usr/bin/phpdcd
# phploc installed version :		https://phar.phpunit.de/phploc.phar
# phploc download location :		/usr/local/src/phploc/phploc.phar
# phploc executable location :		/usr/bin/phploc
# composer installed version :		https://getcomposer.org/installer
# composer download location :		/usr/local/src/composer/composer.phar
# composer executable location :	/usr/bin/composer
# ----------------------------------------------------------------------------------------------
ADD toolsInstall.sh /toolsInstall.sh
RUN bash /toolsInstall.sh && rm /toolsInstall.sh
# --------------------------------------- END 6 ------------------------------------------------



# ---------------------------------------START 7------------------------------------------------
# Supervisor configuration
#
# Adding apache2, mysql, ssh, rsyslog and cron to supervisor
# ----------------------------------------------------------------------------------------------
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# --------------------------------------- END 7 ------------------------------------------------



# ---------------------------------------START 8------------------------------------------------
# Creating 'remote' user with ssh access and sudo capacity
# ----------------------------------------------------------------------------------------------
ADD bashrc /remoteBashrc
ADD bash_profile /remoteBash_profile
ADD createRemoteUser.sh /createRemoteUser.sh
RUN bash /createRemoteUser.sh && rm /createRemoteUser.sh
# --------------------------------------- END 8 ------------------------------------------------



# ---------------------------------------START 9------------------------------------------------
# Finalization
#
# You can add your tools here
# ----------------------------------------------------------------------------------------------
ADD userInstall.sh /userInstall.sh
RUN bash /userInstall.sh && rm /userInstall.sh
# --------------------------------------- END 9 ------------------------------------------------



RUN updatedb

EXPOSE 80 3306 8080 22
VOLUME ["/mnt/hostShared"]

ENTRYPOINT supervisord -n
