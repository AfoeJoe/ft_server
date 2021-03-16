#!/bin/bash

#Start mysql
service mysql start

# Config Access
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

# Generate website folder
mkdir /var/www/my_site

# Generate ssl certificate
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/my_site.pem \
    -keyout /etc/nginx/ssl/my_site.key \
    -subj "/C=RU/ST=Tatarstan/L=Kazan/O=21 school/OU=tkathy/CN=Josh/emailAddress=okunola_joshua@yahoo.com"

# Configure NGINX
rm -rf /etc/nginx/sites-enabled/default
mv ./tmp/my_site /etc/nginx/sites-available/my_site
#replace the autoinddex value
sed -i "s/__AI__/${AI}/g" /etc/nginx/sites-available/my_site
ln -s /etc/nginx/sites-available/my_site /etc/nginx/sites-enabled/my_site

# Configure MYSQL
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

# Download and configure phpmyadmin
mkdir /var/www/my_site/phpmyadmin
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.gz
tar -xvf phpMyAdmin-latest-english.tar.gz --strip-components 1 -C /var/www/my_site/phpmyadmin
rm -rf phpMyAdmin-latest-english.tar.gz
mv ./tmp/phpmyadmin.inc.php /var/www/my_site/phpmyadmin/config.inc.php

#WP CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Download and, install and configure Wordpress
wp core download --path=wordpress --allow-root
wp config create --dbname=wordpress --dbuser=root --dbpass= --dbhost=localhost --dbprefix=wp_ --path=wordpress --allow-root
mv wordpress /var/www/my_site/ 

#start the sercvices
service php7.3-fpm start
service nginx start
bash