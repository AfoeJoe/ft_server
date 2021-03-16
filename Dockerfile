################################################
# My custom nginx, wordpress,phpmyadmin and mysql installation
################################################

#set the base installation
FROM debian:buster

#Filr Author / maintainer
LABEL maintainer="afoejoe@gmail.com"

#update and upgrade
RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y wget



#install necessary services
RUN apt-get install -y nginx php-fpm php-mysql default-mysql-server php-xml


#ADD FILES TO /tmp/ directory
COPY ./srcs/init.sh ./
COPY ./srcs/my_site ./tmp/my_site
COPY ./srcs/phpmyadmin.inc.php ./tmp/phpmyadmin.inc.php

#SET AUTOINDEX TO ON
ENV AI=on

#Run script on start
CMD ["bash","init.sh"]