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
            tzdata \
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
EXPOSE 5000

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
