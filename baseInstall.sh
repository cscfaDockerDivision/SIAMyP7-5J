#! /bin/bash

apt-get -y update
apt-get install -y \
	wget \
	apt-utils \
	build-essential \
	supervisor \
	locate \
	nano \
	python-software-properties \
	software-properties-common \
	subversion \
	openssh-server \
	sudo \
	language-pack-en-base \
	zip \
	unzip \
	git \
	nodejs \
	npm \
	ant \
	rsyslog \
	man-db

apt-get -y upgrade
