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
		cron \
		zip \
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

#Install mysql client, unzip and git
RUN     set -eux; \
        apt-get update; \
		apt-get -y install default-mysql-client unzip git curl; \
		apt-get clean
# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Install redis dependency
RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini
# Install apcu dependency
ARG APCU_VERSION=5.1.18
RUN pecl install apcu-${APCU_VERSION} && docker-php-ext-enable apcu
RUN rm -rf /tmp/pear
RUN echo "extension=apcu.so" >> /usr/local/etc/php/apcu.ini
RUN echo "apc.enable_cli=1" >> /usr/local/etc/php/apcu.ini
RUN echo "apc.enable=1" >> /usr/local/etc/php/apcu.ini
#APCU
# Upload progress
RUN git clone https://github.com/php/pecl-php-uploadprogress/ /usr/src/php/ext/uploadprogress/ && \
    docker-php-ext-configure uploadprogress && \
    docker-php-ext-install uploadprogress
# Uploadprogress
# cron
RUN apt update;\
    apt install -y cron libtool; \
    apt clean
# cron
##Iconv
RUN rm /usr/bin/iconv \
  && curl -SL http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz | tar -xz -C . \
  && cd libiconv-1.14 \
  && ./configure --prefix=/usr/local \
  && curl -SL https://raw.githubusercontent.com/mxe/mxe/7e231efd245996b886b501dad780761205ecf376/src/libiconv-1-fixes.patch \
  | patch -p1 -u  \
  && make \
  && make install \
  #&& libtool --finish /usr/local/lib \
  && cd .. \
  && rm -rf libiconv-1.14

ENV LD_PRELOAD /usr/local/lib/preloadable_libiconv.so
## Iconv



COPY --from=composer:1.10 /usr/bin/composer /usr/local/bin/

ENV DRUSH_VERSION=9.7.2
# Install Drush
WORKDIR /var/www
USER root
RUN mkdir /var/www/.composer
RUN composer global require drush/drush:$DRUSH_VERSION  && \
    composer global update
RUN mkdir /drush
RUN mv /root/.composer /drush
ENV PATH=$PATH:/drush/.composer/vendor/bin


