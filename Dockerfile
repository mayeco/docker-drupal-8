FROM drupal:8

# add the Twig C extension
# https://www.drupal.org/node/2160643

# add the uploadprogress extension
# https://www.drupal.org/node/793264

RUN mkdir /tmp/twig_ext
WORKDIR /tmp/twig_ext

ENV TWIG_VERSION 1.22.3
ENV TWIG_MD5 41245d409760a0a1d27108a5470e2f6f

RUN curl -fSL "https://github.com/twigphp/Twig/archive/v${TWIG_VERSION}.tar.gz" -o twig.tar.gz \
    && echo "${TWIG_MD5} *twig.tar.gz" | md5sum -c - \
    && tar -xz --strip-components=1 -f twig.tar.gz \
    && rm twig.tar.gz \
    && cd /tmp/twig_ext/ext/twig && phpize \
    && ./configure && make && make install \
    && echo "extension=twig.so" > /usr/local/etc/php/conf.d/docker-php-ext-twig.ini \
    && cp /tmp/twig_ext/ext/twig/modules/twig.so $(php-config --extension-dir) \
    && cd /tmp && rm -vrf /tmp/twig_ext \
    && pecl channel-update pecl.php.net \
    && pecl install uploadprogress \
    && echo "extension=uploadprogress.so" > /usr/local/etc/php/conf.d/docker-php-ext-uploadprogress.ini \
    && rm -vrf /build /tmp/pear

WORKDIR /var/www/html
