FROM alpine:edge

LABEL maintainer="Jozef Rebjak"

ARG VERSION=2.4.1

ENV TZ Europe/Bratislava

RUN set -x \
  \
  && echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
  && apk add --no-cache --virtual .build-deps \
    mariadb-dev \
    postgresql-dev \
    boost-dev \
    log4cplus-dev \
    autoconf \
    make \
    automake \
    libtool \
    g++ \
  \
  ## Build Kea
  && cd / \
  && wget -O kea.tar.gz https://downloads.isc.org/isc/kea/$VERSION/kea-$VERSION.tar.gz \
  && mkdir -p /usr/src/kea \
  && tar xf kea.tar.gz --strip-components=1 -C /usr/src/kea \
  && rm kea.tar.gz \
  && cd /usr/src/kea \
  \
  && autoreconf \
    --install \
  && CXXFLAGS='-Os' ./configure \
    # Define the installation location (the default is /usr/local).
    --prefix=/usr/local \
    --sysconfdir=/etc \
    --localstatedir=/var \
    # Build Kea with code to allow it to store leases and host reservations in a MySQL database.
    --with-mysql \
    # Build Kea with code to allow it to store leases and host reservations in a PostgreSQL database.
    --with-pgsql \
    # Use the OpenSSL cryptographic library instead of Botan.
    # By default configure searches for a valid Botan installation; if one is not found, Kea searches for OpenSSL. Normally this is not necessary.
    --with-openssl \
    --enable-static=false \
  && make -j "$(getconf _NPROCESSORS_ONLN)" \
  && make install \
  \
  ## Cleanup
  && cd / \
  && rm -rf /usr/src \
  \
  && runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  )" \
  && apk add --virtual .kea-rundeps $runDeps \
  && apk del .build-deps
