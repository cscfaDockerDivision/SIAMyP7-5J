#! /bin/bash

mkdir /usr/local/src/phpunit

mkdir /usr/local/src/phpunit/latest && \
	wget https://phar.phpunit.de/phpunit.phar -O /usr/local/src/phpunit/latest/phpunit.phar && \
	chmod +x /usr/local/src/phpunit/latest/phpunit.phar && \
	ln -s /usr/local/src/phpunit/latest/phpunit.phar /usr/bin/phpunit

mkdir /usr/local/src/phpunit/4.8 && \
	wget https://phar.phpunit.de/phpunit-4.8.9.phar -O /usr/local/src/phpunit/4.8/phpunit.phar && \
	chmod +x /usr/local/src/phpunit/4.8/phpunit.phar && \
	ln -s /usr/local/src/phpunit/4.8/phpunit.phar /usr/bin/phpunit48

mkdir /usr/local/src/phpunit/5.6 && \
	wget https://phar.phpunit.de/phpunit-5.6.1.phar -O /usr/local/src/phpunit/5.6/phpunit.phar && \
	chmod +x /usr/local/src/phpunit/5.6/phpunit.phar && \
	ln -s /usr/local/src/phpunit/5.6/phpunit.phar /usr/bin/phpunit56

mkdir /usr/local/src/composer && \
	wget https://getcomposer.org/installer -O /usr/local/src/composer/composer-setup.php && \
	php /usr/local/src/composer/composer-setup.php --install-dir=/usr/local/src/composer/ && \
	rm /usr/local/src/composer/composer-setup.php && \
	chmod +x /usr/local/src/composer/composer.phar && \
	ln -s /usr/local/src/composer/composer.phar /usr/bin/composer

mkdir /usr/local/src/phpcs && \
	wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar -O /usr/local/src/phpcs/phpcs.phar && \
	chmod +x /usr/local/src/phpcs/phpcs.phar && \
	ln -s /usr/local/src/phpcs/phpcs.phar /usr/bin/phpcs

mkdir /usr/local/src/phpcbf && \
	wget https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar -O /usr/local/src/phpcbf/phpcbf.phar && \
	chmod +x /usr/local/src/phpcbf/phpcbf.phar && \
	ln -s /usr/local/src/phpcbf/phpcbf.phar /usr/bin/phpcbf

mkdir /usr/local/src/phpmd && \
	wget http://static.phpmd.org/php/latest/phpmd.phar -O /usr/local/src/phpmd/phpmd.phar && \
	chmod +x /usr/local/src/phpmd/phpmd.phar && \
	ln -s /usr/local/src/phpmd/phpmd.phar /usr/bin/phpmd

mkdir /usr/local/src/sami && \
	wget http://get.sensiolabs.org/sami.phar -O /usr/local/src/sami/sami.phar && \
	chmod +x /usr/local/src/sami/sami.phar && \
	ln -s /usr/local/src/sami/sami.phar /usr/bin/sami

mkdir /usr/local/src/phpcpd && \
	wget https://phar.phpunit.de/phpcpd.phar -O /usr/local/src/phpcpd/phpcpd.phar && \
	chmod +x /usr/local/src/phpcpd/phpcpd.phar && \
	ln -s /usr/local/src/phpcpd/phpcpd.phar /usr/bin/phpcpd

mkdir /usr/local/src/phpdcd && \
	wget https://phar.phpunit.de/phpdcd.phar -O /usr/local/src/phpdcd/phpdcd.phar && \
	chmod +x /usr/local/src/phpdcd/phpdcd.phar && \
	ln -s /usr/local/src/phpdcd/phpdcd.phar /usr/bin/phpdcd

mkdir /usr/local/src/phploc && \
	wget https://phar.phpunit.de/phploc.phar -O /usr/local/src/phploc/phploc.phar && \
	chmod +x /usr/local/src/phploc/phploc.phar && \
	ln -s /usr/local/src/phploc/phploc.phar /usr/bin/phploc
