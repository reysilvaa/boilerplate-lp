#!/bin/sh
set -e

if [ "$DB_CONNECTION" = "sqlite" ] || [ -z "$DB_CONNECTION" ]; then
    mkdir -p database
    touch database/database.sqlite
fi

php artisan config:clear || true
php artisan route:clear || true
php artisan view:clear || true

php artisan migrate --force || true
php artisan pbm:create-admin --name=Admin --email=admin@gmail.com --password=password123 || true

exec php artisan serve --host=0.0.0.0 --port="${PORT:-8080}"
