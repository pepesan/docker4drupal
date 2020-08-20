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



#Copiando Drupal
WORKDIR /var/www



ENV PATH=${PATH}:/opt/drupal/vendor/bin

# Install Drush
WORKDIR /var/www
USER root
RUN mkdir /var/www/.composer
RUN composer global require drush/drush  && \
    composer global update
RUN mkdir /drush
RUN mv /root/.composer /drush
ENV PATH=$PATH:/drush/.composer/vendor/bin

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 8.9.3
USER root
COPY drupal /drupal
RUN set -eux; \
    cp -rp /drupal/* /var/www/
RUN set -eux; \
    chmod -R 755 /var/www; \
    chown -R www-data:www-data /var/www
# RUN mkdir /var/www/web/sites/default/files
# Copiando el fichero de configuración
COPY settings.php web/sites/default
RUN set -eux; \
    chmod -R 640 web/sites/default/settings.php; \
    chown -R www-data:www-data web/sites/default/settings.php; \
	rmdir /var/www/html; \
	ln -sf /var/www/web /var/www/html;

#RUN set -eux; \
#    export RANDOM_SALT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1); \
#    echo "\$settings['hash_salt']='${RANDOM_SALT}';" >> /var/www/web/sites/default/settings.php

#COPY entrypoint-app.sh /bin
#RUN chmod +x /bin/entrypoint-app.sh
#ENTRYPOINT ["/bin/entrypoint-app.sh"]
VOLUME /var/www/web/sites/default/files
EXPOSE 9000