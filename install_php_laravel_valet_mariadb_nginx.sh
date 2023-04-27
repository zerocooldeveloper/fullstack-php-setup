#!/bin/bash

# Instalador de PHP, Laravel, Valet, MariaDB, Nginx y phpMyAdmin
# Copyright (C) 2023 Noé Francisco Martínez Merino
# email: noe.martinez@hifenix.com

# Actualizar repositorios y paquetes
apt-get update
apt-get upgrade -y

# Instalar dependencias necesarias
apt-get install -y software-properties-common

# Agregar el repositorio de Ondřej Surý para las versiones de PHP
add-apt-repository -y ppa:ondrej/php
apt-get update

# Mostrar las versiones de PHP disponibles
echo "Versiones de PHP disponibles:"
versions=$(apt-cache madison php | grep -E -o 'php\d+(\.\d+)?' | sort -Vr | uniq)
echo "$versions"

# Leer la versión de PHP que se desea instalar
read -p "Ingrese la versión de PHP que desea instalar (ejemplo: php7.4): " php_version

# Instalar la versión seleccionada de PHP y algunas extensiones comunes
apt-get install -y $php_version $php_version-cli $php_version-common $php_version-mbstring $php_version-xml $php_version-json $php_version-zip $php_version-mysql

# Instalar Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar el PATH para Composer
echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Instalar Laravel globalmente
composer global require laravel/installer

# Instalar Valet para Linux
composer global require cpriego/valet-linux
valet install

# Instalar MariaDB
apt-get install -y mariadb-server

# Pedir al usuario que ingrese la contraseña de root para MariaDB
read -sp "Ingrese la contraseña que desea asignar al usuario root de MariaDB: " mariadb_root_password
echo

# Configurar la contraseña de root para MariaDB
mysql -u root <<-EOF
UPDATE mysql.user SET Password=PASSWORD('$mariadb_root_password') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

# Instalar Nginx
apt-get install -y nginx

# Instalar phpMyAdmin
apt-get install -y phpmyadmin

# Configurar phpMyAdmin para Nginx
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

# Reiniciar el shell para aplicar los cambios en el PATH
exec $SHELL
