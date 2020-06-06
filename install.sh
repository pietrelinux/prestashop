#!/bin/sh
add-apt-repository ppa:ondrej/php -y
mkdir /var/www/html/linuxsmallfactor.com
apt upgrade -y
adduser prestashop
add-apt-repository ppa:ondrej/php
apt install nginx fail2ban bash-completion ufw unzip mysql-server mysql-client php7.3-common php7.3-cli php7.3-fpm php7.3-opcache php7.3-gd php7.3-mysql php7.3-curl php7.3-intl php7.3-xsl php7.3-mbstring php7.3-zip php7.3-bcmath php7.3-soap -y
ufw allow 'Nginx Full'
systemctl enable nginx
mysql
mysql CREATE DATABASE prestashop;
GRANT ALL ON prestashop.* TO 'prestashop'@'localhost' IDENTIFIED BY 'lalalilo';
EXIT;

sed -i "s/memory_limit = .*/memory_limit = 1024M/" /etc/php/7.3/fpm/php.ini

sed -i "s/upload_max_filesize = .*/upload_max_filesize = 256M/" /etc/php/7.3/fpm/php.ini

sed -i "s/zlib.output_compression = .*/zlib.output_compression = on/" /etc/php/7.3/fpm/php.ini

sed -i "s/max_execution_time = .*/max_execution_time = 18000/" /etc/php/7.3/fpm/php.ini

sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.3/fpm/php.ini

sed -i "s/;opcache.save_comments.*/opcache.save_comments = 1/" /etc/php/7.3/fpm/php.ini

cd /tmp/

wget -c https://github.com/PrestaShop/PrestaShop/releases/download/1.7.6.5/prestashop_1.7.6.5.zip

unzip prestashop_*.zip
unzip prestashop.zip -d /var/www/html/linuxsmallfactor.com
cd ..

sudo mkdir -p /var/www/html/linuxsmallfactor.com

unzip prestashop_*.zip

unzip prestashop.zip -d /var/www/html/linuxsmallfactor.com
chown -R www-data: /var/www/html


> /etc/nginx/sites-available/linuxsmallfactor.com
cat <<+ >> /etc/nginx/sites-available/linuxsmallfactor.com

# Redirect HTTP -> HTTPS
server {
    listen 80;
    server_name www.linuxsmallfactor.com linuxsmallfactor.com;
    include snippets/letsencrypt.conf;
    return 301 https://linuxsmallfactor.com$request_uri;
}
# Redirect WWW -> NON WWW
server {
    listen 443 ssl http2;
    server_name www.linuxsmallfactor.com;
    ssl_certificate /etc/letsencrypt/live/linuxsmallfactor.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/linuxsmallfactor.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/linuxsmallfactor.com/chain.pem;
    include snippets/ssl.conf;
    return 301 https://linuxsmallfactor.com$request_uri;
}
server {
    listen 443 ssl http2;
    server_name linuxsmallfactor.com;
    root /var/www/html/linuxsmallfactor.com;
    index index.php;
    # SSL parameters
    ssl_certificate /etc/letsencrypt/live/linuxsmallfactor.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;
    include snippets/ssl.conf;
    include snippets/letsencrypt.conf;
    # log files
    access_log /var/log/nginx/linuxsmallfactor.com.access.log;
    error_log /var/log/nginx/linuxsmallfactor.com.error.log;
    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }
    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }
    location / {
        try_files $uri $uri/ /index.php?$args;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.3-fpm.sock;
    }
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires max;
        log_not_found off;
    }
}
+
chmod
nginx -t

systemctl restart nginx
reboot
