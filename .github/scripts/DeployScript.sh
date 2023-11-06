#!/bin/sh
set -e

echo "Deploying application ..."

# maintenance mode
php artisan down
echo 'Pulling main we are'
git stash
git pull origin main

COMPOSER_ALLOW_SUPERUSER=1 composer install --no-interaction --prefer-dist --optimize-autoloader

/root/.nvm/versions/node/v21.1.0/bin/npm install
/root/.nvm/versions/node/v21.1.0/bin/npm run build

php artisan migrate --force
php artisan optimize
chmod -R 777 storage bootstrap/cache

# Reload PHP to update opcache
echo "" | sudo -S service php8.1-fpm reload

# Exit maintenance mode
php artisan up

echo "Application deployed!"