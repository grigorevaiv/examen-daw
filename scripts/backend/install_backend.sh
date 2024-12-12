#!/bin/bash
set -ex

source .env

apt update
apt upgrade -y

apt install mysql-server -y

sed -i "s/127.0.0.1/$BACKEND_IP/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root <<< "CREATE DATABASE $DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'$IP_MAQUINA_CLIENTE'"
mysql -u root <<< "CREATE USER '$DB_USER'@'$IP_MAQUINA_CLIENTE' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$IP_MAQUINA_CLIENTE'"
