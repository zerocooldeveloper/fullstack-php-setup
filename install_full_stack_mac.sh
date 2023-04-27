#!/bin/bash

# Instalador de PHP, Laravel, Valet, MariaDB
# Copyright (C) 2023 Noé Francisco Martínez Merino
# email: noe.martinez@hifenix.com
# Instalar Homebrew si no está instalado

if test ! $(which brew); then
  echo "Instalando Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Actualizar Homebrew y los paquetes
echo "Actualizando Homebrew y los paquetes..."
brew update
brew upgrade

# Instalar PHP y Composer
echo "Instalando PHP y Composer..."
brew install php composer

# Instalar Laravel Valet
echo "Instalando Laravel Valet..."
composer global require laravel/valet
valet install

# Instalar MariaDB
echo "Instalando MariaDB..."
brew install mariadb

# Configurar la contraseña de root para MariaDB
echo "Configurando la contraseña de root para MariaDB..."
mysql_secure_installation

# Instalar Nginx
echo "Instalando Nginx..."
brew install nginx

# Configurar Valet para usar Nginx en lugar de Apache
echo "Configurando Valet para usar Nginx en lugar de Apache..."
valet use nginx

echo "Hecho."
