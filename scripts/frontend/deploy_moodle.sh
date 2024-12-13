#!/bin/bash
source .env

rm -rf /tmp/moodle.zip
rm -rf /var/www/html/*

wget https://github.com/moodle/moodle/archive/refs/tags/v4.5.1.zip -P /tmp

sudo apt update && sudo apt install -y unzip

unzip /tmp/v4.5.1.zip -d /tmp

mv -f /tmp/moodle-4.5.1/* /var/www/html/

rm -f /tmp/v4.5.1.zip
rm -rf /tmp/moodle-4.5.1
mkdir -p $DATAROOT
chmod 775 $DATAROOT
chown -R www-data:www-data $DATAROOT
# Устанавливаем Moodle через CLI
sudo -u www-data /usr/bin/php /var/www/html/admin/cli/install.php \
    --lang=$LANG \
    --wwwroot=$WWWROOT \
    --dataroot=$DATAROOT \
    --dbtype=$DBTYPE \
    --dbhost=$DBHOST \
    --dbname=$DBNAME \
    --dbuser=$DBUSER \
    --dbpass=$DBPASS \
    --fullname="$FNAME" \
    --shortname=$SNAME \
    --adminuser=$ADMIN \
    --adminpass=$ADMINPASS \
    --adminemail=$ADMINMAIL \
    --non-interactive \
    --agree-license
