# from https://www.drupal.org/docs/8/system-requirements/drupal-8-php-requirements
FROM php:7.4-fpm-buster

# install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
		libzip-dev \
		unzip \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg=/usr \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
	; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# https://github.com/drupal/drupal/blob/9.0.1/composer.lock#L4052-L4053
COPY --from=composer:1.10 /usr/bin/composer /usr/local/bin/

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 8.9.3

WORKDIR /var/www
RUN set -eux; \
	export COMPOSER_HOME="$(mktemp -d)"; \
	rmdir /var/www/html; \
	composer create-project --no-interaction "drupal/recommended-project:$DRUPAL_VERSION" ./; \
	chown -R www-data:www-data web/sites web/modules web/themes; \
	mkdir /var/www/html; \
	ln -sf /var/www/web /var/www/html; \
	# delete composer cache
	rm -rf "$COMPOSER_HOME"


ENV PATH=${PATH}:/opt/drupal/vendor/bin

# Install Drush
USER www-data
WORKDIR /var/www
USER root
RUN mkdir /var/www/.composer
RUN composer global require drush/drush  && \
    composer global update
RUN mkdir /drush
RUN mv /root/.composer /drush
ENV PATH=$PATH:/drush/.composer/vendor/bin


