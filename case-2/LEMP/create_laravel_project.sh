#!/bin/bash

echo "Starting LEMP stack..."
docker-compose up -d

echo "Installing dependencies and Composer inside PHP container..."
docker exec -it php bash -c "
  apt-get update && \
  apt-get install -y git unzip zip curl libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev && \
  docker-php-ext-install pdo mbstring gd dom && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
"

echo "Creating Laravel project..."
docker exec -it php bash -c "
  cd /var/www/html && \
  composer create-project laravel/laravel . && \
  chmod -R 775 storage bootstrap/cache
"

echo "Updating Laravel's default route..."
docker exec -it php bash -c "echo \"<?php
use Illuminate\Support\Facades\Route;

docker exec -it php bash -c "
  chown -R www-data:www-data /var/www/html && \
  chmod -R 775 /var/www/html
"

Route::get('/', function () {
    return 'Hello World! My name is YourName';
});\" > /var/www/html/routes/web.php"

