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
RUN apk add --no-cache --virtual .letschat-rundeps \
            git \
            logrotate \
            supervisor \
            $NULL
RUN apk add --no-cache \
            vim \
            bash \
            less \
            $NULL

# Define working directory.
WORKDIR $HOME

# Setup lets-chat
RUN git clone -b aim-for-stable https://github.com/t-kenji/lets-chat.git && \
    cd lets-chat && \
    npm install
COPY conf/lets-chat/settings.yml lets-chat/

# Setup supervisor
RUN mkdir -p /etc/supervisor.d
COPY conf/supervisor/letschat.ini /etc/supervisor.d/

COPY script/docker-entrypoint.sh /

# Port forwarding target.
EXPOSE 5000 5222

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
