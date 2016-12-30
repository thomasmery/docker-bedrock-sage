FROM php:7.0-fpm

ARG THEME_NAME
ENV THEME_NAME=${THEME_NAME}

# install Utils & the PHP extensions we need
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    git \
  	zip \
  	unzip \
  	libjpeg-dev \
	libpng12-dev \
	; \
	rm -rf /var/lib/apt/lists/*; \
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install gd mysqli opcache \
	&& pecl install xdebug-2.4.1 \
	&& docker-php-ext-enable xdebug \

 # xdebug options
RUN { \
  echo 'xdebug.remote_enable=1'; \
  echo 'xdebug.remote_autostart=1'; \
  echo 'xdebug.remote_port=9000'; \
  echo 'xdebug.remote_host=remote_host'; \
} > /usr/local/etc/php/conf.d/xdebug.ini

# Node & Npm
RUN curl -sL https://deb.nodesource.com/setup_7.x | /bin/sh -c bash - \
	&& apt-get install -y build-essential \
	&& apt-get install -y nodejs

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
	&& apt-get update \
	&& apt-get install -y yarn

# install composer
ENV PATH /root/.composer/vendor/bin:$PATH
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/bin

# install Bedrock at a location where it will be available for
# copying by the entrypoint script or just to have it available for Composer cache
RUN composer create-project roots/bedrock /usr/src/bedrock; \
	chown -R www-data:www-data /usr/src/bedrock

# install Sage Starter theùe at a location where it will be available for
# copying by the entrypoint script or just to have it available for Composer cache
RUN composer create-project roots/sage /usr/src/sage dev-master; \
	chown -R www-data:www-data /usr/src/sage

# install WP CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
	chmod +x wp-cli.phar; \
	mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www
VOLUME /var/www

# ENTRYPOINT script
COPY bedrock-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/bedrock-entrypoint.sh

ENTRYPOINT ["bedrock-entrypoint.sh"]
CMD ["php-fpm"]