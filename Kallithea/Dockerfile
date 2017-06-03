#
# Dockerfile for Kallithea Container.
#

# Pull base image.
FROM python:2.7-alpine

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root
ENV LANG=C.UTF-8
ENV RCDATA=/var/lib/kallithea/data

# Set data volume.
VOLUME $RCDATA

# Install packages.
RUN apk update
RUN apk add --no-cache \
            curl \
            gcc \
            g++ \
            git \
            git-svn \
            libffi-dev \
            logrotate \
            mercurial \
            postgresql-dev \
            supervisor \
            $NULL
RUN apk add --no-cache \
            vim \
            bash \
            $NULL

RUN pip install --no-cache-dir \
                virtualenv \
                $NULL

# Define working directory.
WORKDIR $HOME

COPY script/docker-entrypoint.sh /

# Setup supervisor
RUN mkdir -p /etc/supervisor.d
COPY conf/supervisor/*.ini /etc/supervisor.d/
COPY conf/logrotate/supervisor /etc/logrotate.d/

# Port forwarding target.
EXPOSE 5010

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
