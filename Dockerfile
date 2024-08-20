FROM php:8.3.2-apache-bookworm

ENV APACHE_DOCUMENT_ROOT /home/web
ENV TZ="Europe/Paris"
ENV PHP_CHARSET="utf-8"

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
#COPY "php-conf/php.ini" "/usr/local/etc/php/php.ini"
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

#Probably not needed for Symfony
RUN pear config-set php_ini /usr/local/etc/php/php.ini
RUN pecl config-set php_ini /usr/local/etc/php/php.ini

RUN  apt clean && apt update && apt install -y \
        libmagickwand-dev \
        libyaml-dev \
        libpng-dev \
        zlib1g-dev \
        libzip-dev \
        libxml2-dev \
        libxslt-dev \
        libbz2-dev \
        libssl-dev \
        pdftk \
        vim \
        wget \
        iproute2 \
        iputils-ping \
        git \
        unzip \
        libssh2-1 libssh2-1-dev \
        locales \
        gettext \
        mariadb-client \
        nano \
        gnupg \
        cron \
#        python3-pip \
        nodejs npm \
#        php-xml \
#        php-curl \
        && apt clean \
        && rm -rf /var/lib/apt/lists/*

# Node
#SET command = "alias node=nodejs";
## Ajoute la ligne $command dans le fichier /root/.bashrc
#RUN echo $command >> /root/.bashrc


## Php extensions
RUN docker-php-ext-configure gd --with-jpeg --with-freetype
RUN docker-php-ext-install pdo_mysql gettext bcmath calendar exif mysqli pcntl shmop sockets sysvmsg sysvsem sysvshm gd zip xsl bz2 soap
RUN pecl install xdebug-3.3.1 && docker-php-ext-enable xdebug
RUN pecl install yaml && docker-php-ext-enable yaml
RUN pecl install igbinary && docker-php-ext-enable igbinary
RUN a2enmod rewrite

# Apache config
COPY "apache-conf/ports.conf" "/etc/apache2"
COPY "apache-conf/000-default.conf" "/etc/apache2/sites-available"
EXPOSE 80
RUN ln -s /usr/local/bin/php /usr/bin/php

# Php config
COPY "php-conf/000-main.ini" "/usr/local/etc/php/conf.d/"
COPY "php-conf/001-xdebug.ini" "/usr/local/etc/php/conf.d/"

# Composer 2.2
COPY --from=composer:2.2 /usr/bin/composer /usr/local/bin/composer

# ssl
#RUN mkdir -p /etc/apache2/ssl/
#COPY ssl/ssl.crt /etc/apache2/ssl/ssl.crt
#COPY ssl/ssl.key /etc/apache2/ssl/ssl.key
#COPY ssl/ssl.conf /etc/apache2/conf-enabled/10-ssl.conf
#RUN a2enmod ssl
#EXPOSE 443

# Start
COPY sh/start.sh /tmp/start.sh
RUN chmod 777 /tmp/start.sh
CMD ["/tmp/start.sh"]

# Locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen
ENV LC_ALL fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:fr

# Python
#ENV PYTHONUNBUFFERED=1
#RUN pip3 install --no-cache --upgrade pip setuptools

WORKDIR /home/web/