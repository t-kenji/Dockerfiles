#
# Dockerfile for Trac Container.
#

# Pull base image.
FROM python:2.7-alpine

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root
ENV LANG=en_US.utf8
ENV TRACDATA=/var/lib/trac

# Set data volume.
VOLUME $TRACDATA

# Install packages.
RUN apk add --no-cache \
            curl \
            gcc \
            g++ \
            git \
            git-svn \
            libffi-dev \
            libjpeg-turbo-dev \
            libpng-dev \
            logrotate \
            mercurial \
            postgresql-dev \
            sqlite-dev \
            supervisor \
            zlib-dev \
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

# Setup trac.
COPY script/bootstrap.py $HOME

# Setup supervisor
RUN mkdir -p /etc/supervisor.d
COPY conf/logrotate/supervisor /etc/logrotate.d/

# Expose port.
EXPOSE 8001-8009

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
