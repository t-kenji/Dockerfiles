#
# Dockerfile for Nginx Container.
#

# Pull base image.
FROM alpine:3.6

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root
ENV LANG=C.UTF-8
ENV CERTDATA=/usr/share/certs
ENV WWWDATA=/usr/share/www-data

# Set data volume.
VOLUME $CERTDATA
VOLUME $WWWDATA

# Install packages.
RUN apk update
RUN apk add --no-cache --virtual .nginx-rundeps \
            ca-certificates \
            libaio \
            libressl \
            pcre \
            zlib \
            $NULL
RUN apk add --no-cache --virtual .nginx-builddeps \
            build-base \
            git \
            libaio-dev \
            libressl-dev \
            linux-headers \
            pcre-dev \
            zlib-dev \
            $NULL
RUN apk add --no-cache \
            vim \
            bash \
            $NULL

# Define working directory.
WORKDIR $HOME

COPY script/docker-entrypoint.sh /

# Setup nginx.
RUN git clone https://github.com/atomx/nginx-http-auth-digest.git
RUN git clone -b release-1.13.4 https://github.com/nginx/nginx.git \
    && cd nginx \
    && ./auto/configure \
       --prefix=/etc/nginx \
       --sbin-path=/usr/sbin/nginx \
       --conf-path=/etc/nginx/nginx.conf \
       --error-log-path=/var/log/nginx/error.log \
       --http-log-path=/var/log/nginx/access.log \
       --pid-path=/var/run/nginx.pid \
       --lock-path=/var/run/nginx.lock \
       --http-client-body-temp-path=/var/cache/nginx/client_temp \
       --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
       --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
       --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
       --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
       --user=nginx \
       --group=nginx \
       --with-file-aio \
       --with-http_addition_module \
       --with-http_auth_request_module \
       --with-http_gunzip_module \
       --with-http_gzip_static_module \
       --with-http_realip_module \
       --with-http_slice_module \
       --with-http_ssl_module \
       --with-http_stub_status_module \
       --with-http_v2_module \
       --with-stream \
       --with-stream_realip_module \
       --with-stream_ssl_module \
       --with-threads \
       --add-module=../nginx-http-auth-digest \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && adduser -D nginx \
    && mkdir -p /var/cache/nginx

COPY conf/nginx/nginx.conf /etc/nginx/
COPY conf/nginx/conf.d/*.conf /etc/nginx/conf.d/

# Port forwarding target.
EXPOSE 80 443 8089 8989

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
