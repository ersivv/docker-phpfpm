FROM php:fpm

# Install extensions
RUN buildDeps=" \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		libpng12-dev \
		zlib1g-dev \
		libicu-dev \
		libxml2-dev \
		libaio-dev \
		libmemcached-dev \
		freetds-dev \
		libssl-dev \
		openssl \
	"; \
	set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
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
	
# Clean repository
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*