#
# Dockerfile for Let's Chat Container.
#

# Pull base image.
FROM node:6-alpine

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root
ENV LANG=C.UTF-8

# Install packages.
RUN apk update
RUN apk add --no-cache \
            curl \
            git \
            git-svn \
            logrotate \
            supervisor \
            $NULL
RUN apk add --no-cache \
            vim \
            bash \
            $NULL

# Define working directory.
WORKDIR $HOME

COPY script/docker-entrypoint.sh /
COPY patches/settings.yml.patch $HOME

# Setup supervisor
RUN mkdir -p /etc/supervisor.d
COPY conf/supervisor/letschat.ini /etc/supervisor.d/

# Port forwarding target.
EXPOSE 5000

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
