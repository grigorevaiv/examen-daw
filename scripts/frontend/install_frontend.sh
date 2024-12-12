#!/bin/bash
set -ex

export DEBIAN_FRONTEND=noninteractive

apt update
apt upgrade -y


apt install apache2 -y

cp ../conf/000-default.conf /etc/apache2/sites-available

apt install php libapache2-mod-php php-mysql php-xml php-mbstring php-curl php-zip php-gd php-intl php-soap -y

echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y

sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.3/apache2/php.ini
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.3/cli/php.ini

a2enmod rewrite

systemctl restart apache2

cp ../php/index.php /var/www/html

chown -R www-data:www-data /var/www/html
