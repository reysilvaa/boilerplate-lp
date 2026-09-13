FROM php:8.4-cli-alpine

# Install system dependencies
RUN apk add --no-cache bash git curl libpng libjpeg-turbo freetype libzip icu oniguruma

# Install PHP extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions pdo_mysql pdo_sqlite mbstring bcmath opcache zip intl pcntl

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Install Node.js & npm from official Node alpine image
COPY --from=node:22-alpine /usr/local/bin/ /usr/local/bin/
COPY --from=node:22-alpine /usr/local/lib/node_modules /usr/local/lib/node_modules

WORKDIR /app

# 1. Install PHP dependencies
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader --no-scripts

# 2. Install Node dependencies
COPY package.json ./
RUN npm install

# 3. Copy application code
COPY . .

# 4. Finish composer setup & compile frontend assets
RUN composer dump-autoload --optimize --no-dev \
    && npm run build \
    && rm -rf node_modules

# Storage directories & permissions
RUN mkdir -p storage/framework/sessions storage/framework/views storage/framework/cache storage/logs bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]
