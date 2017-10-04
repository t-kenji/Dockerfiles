#
# Dockerfile for Errbot Container.
#

# Pull base image.
FROM python:3.6-alpine

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root
ENV LANG=C.UTF-8
ENV BOTDATA=/var/lib/errbot/data

# Set data volume.
VOLUME $BOTDATA

# Install packages.
RUN apk update
RUN apk add --no-cache --virtual .errbot-rundeps \
            libffi \
            openssl \
            supervisor \
            tzdata \
            $NULL
RUN apk add --no-cache --virtual .errbot-builddeps \
            gcc \
            g++ \
            git \
            libffi-dev \
            openssl-dev \
            supervisor \
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

# Setup supervisor
RUN mkdir -p /etc/supervisor.d
COPY conf/supervisor/errbot.ini /etc/supervisor.d/
COPY conf/logrotate/supervisor /etc/logrotate.d/

COPY script/docker-entrypoint.sh /

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
