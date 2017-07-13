FROM php:fpm

# Install other needed extensions
RUN buildDeps=" \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		libpng12-dev \
		zlib1g-dev \
		libicu-dev \
		g++ \
		unixodbc-dev \
		libxml2-dev \
		libaio-dev \
		libmemcached-dev \
		freetds-dev \
		libssl-dev \
		openssl \
	"; \
	set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --enable-gd-native-ttf --with-jpeg-dir=/usr/lib/x86_64-linux-gnu --with-png-dir=/usr/lib/x86_64-linux-gnu --with-freetype-dir=/usr/lib/x86_64-linux-gnu \
	&& pecl install redis \
	&& pecl install memcached \
	&& docker-php-ext-install \
			iconv \
			gd \
			mbstring \
			mcrypt \
			mysqli \
			pdo_mysql \
			sockets \
			zip \
	
	&& docker-php-ext-enable \
			redis \
			memcached \
			opcache \
	
	&& apt-get purge -y --auto-remove $buildDeps \
	&& cd /usr/src/php \
	&& make clean