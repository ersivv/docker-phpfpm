FROM php:fpm

# Install util
RUN apt-get update && apt-get install --no-install-recommends -y \
        wget \
        git \
        unzip \
		curl
			
# gd
RUN buildRequirements="libpng12-dev libjpeg-dev libfreetype6-dev" \
	&& apt-get update && apt-get install -y ${buildRequirements} \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/lib \
	&& docker-php-ext-install gd \
	&& apt-get purge -y ${buildRequirements} \
	&& rm -rf /var/lib/apt/lists/*

# pdo_mysql
RUN docker-php-ext-install pdo_mysql

# mysqli
RUN docker-php-ext-install mysqli

# mcrypt
RUN runtimeRequirements="re2c libmcrypt-dev" \
	&& apt-get update && apt-get install -y ${runtimeRequirements} \
	&& docker-php-ext-install mcrypt \
	&& rm -rf /var/lib/apt/lists/*

# mbstring
RUN docker-php-ext-install mbstring

# opcache
RUN docker-php-ext-install opcache

# zip
RUN buildRequirements="zlib1g-dev" \
	&& apt-get update && apt-get install -y ${buildRequirements} \
	&& docker-php-ext-install zip \
	&& apt-get purge -y ${buildRequirements} \
	&& rm -rf /var/lib/apt/lists/*

# redis
RUN wget -O /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/3.0.0.tar.gz \
	&& mkdir -p /tmp/redis \
	&& tar xzf /tmp/redis.tar.gz -C /tmp/redis --strip-components=1 \
	&& cd /tmp/redis \
	&& phpize \
	&& ./configure \
	&& make \
	&& make install \
	&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/ext-redis.ini \
	&& rm -rf /tmp/redis.tar.gz /tmp/redis
	
# memcached
RUN buildRequirements="libmemcached-dev" \
	&& apt-get update && apt-get install -y ${buildRequirements} \
	&& curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p /usr/src/php/ext/memcached \
    && tar -C /usr/src/php/ext/memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
	&& docker-php-ext-configure memcached \
	&& docker-php-ext-install memcached \
	&& apt-get purge -y ${buildRequirements} \
	&& rm -rf /var/lib/apt/lists/*
	
# Clean repository
RUN apt-get clean \
	&& rm -rf /tmp/* /var/cache/apk/* /var/lib/apt/lists/*