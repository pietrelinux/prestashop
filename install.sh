#!/bin/sh

sudo apt-get install mysql-server apache2 libapache2-mod-php7.0 php7.0 php7.0-xml php7.0-gd php7.0-json php7.0-zip php7.0-intl php7.0-mcrypt php7.0-curl php7.0-intl php7.0-opcache mariadb-server php7.0-mysql

a2enmod rewrite
service apache2 restart
a2enmod ssl
service apache2 restart
