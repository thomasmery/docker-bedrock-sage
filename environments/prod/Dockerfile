FROM php:7.0-fpm

# install the PHP extensions we need
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
  docker-php-ext-install gd mysqli opcache


# Node & Npm
RUN curl -sL https://deb.nodesource.com/setup_7.x | /bin/sh -c bash - \
	&& apt-get install -y build-essential \
	&& apt-get install -y nodejs

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
	&& apt-get install -y yarn

# Composer
ENV PATH /root/.composer/vendor/bin:$PATH
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/bin

# remove base image webroot
RUN rm -rf /var/www/html/

# copy site
COPY . /var/www/

# make src files owned by web server
RUN chown -R www-data:www-data /var/www/web

WORKDIR /var/www/

RUN composer install

ENV NODE_ENV=staging
ARG PROJECT_NAME=my-theme
RUN mv /var/www/web/app/themes/sage /var/www/web/app/themes/${PROJECT_NAME}
RUN cd /var/www/web/app/themes/${PROJECT_NAME} \
	&& composer install \
	&& yarn \
	&& yarn run build:production

VOLUME /var/www/
