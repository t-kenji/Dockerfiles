#
# Dockerfile for Nginx Container.
#

# Pull base image.
FROM nginx:mainline-alpine

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root
ENV LANG=C.UTF-8

# Install packages.
RUN apk update
RUN apk add --no-cache --virtual .nginx-rundeps \
            ca-certificates \
            libaio \
            libressl \
            pcre \
            tzdata \
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

# Setup timezone.
RUN rm /etc/localtime \
 && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
 && echo "Asia/Tokyo" > /etc/timezone

# Setup nginx.
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY conf/nginx/*.conf /etc/nginx/conf.d/

COPY script/docker-entrypoint.sh /

# Port forwarding target.
EXPOSE 80 443 8089 8989

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
