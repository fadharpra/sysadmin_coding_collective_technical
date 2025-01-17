#!/bin/bash

# Create a docker-compose.yml file for LEMP stack
cat <<EOF > docker-compose.yml
version: '3.9'

services:
  nginx:
    image: nginx:latest
    container_name: nginx
    ports:
      - "80:80"
    volumes:
      - ./app:/var/www/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    networks:
      - lemp-network

  mariadb:
    image: mariadb:latest
    container_name: mariadb
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: lempdb
      MYSQL_USER: lempuser
      MYSQL_PASSWORD: lemppassword
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - lemp-network

  php:
    image: php:8.1-fpm
    container_name: php
    volumes:
      - ./app:/var/www/html
    networks:
      - lemp-network

volumes:
  db_data:

networks:
  lemp-network:
EOF

# Create default Nginx configuration
cat <<EOF > nginx.conf
server {
    listen 80;
    server_name localhost;
    root /var/www/html/public;
    index index.php index.html;
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    location ~ \.php\$ {
        include fastcgi_params;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}
EOF

# Create Laravel application directory
mkdir -p app
