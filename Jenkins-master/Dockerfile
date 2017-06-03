#
# Dockerfile for Jenkins-master Container.
#

# Pull base image.
FROM jenkins:2.46.3-alpine

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
USER root
ENV HOME=/root
ENV LANG=C.UTF-8
ENV JENKINS_HOME=/var/jenkins_home

# Set data volume.
VOLUME $JENKINS_HOME

# Install packages.
RUN apk update
RUN apk add --no-cache \
            curl \
            logrotate \
            supervisor \
            $NULL
RUN apk add --no-cache \
            vim \
            bash \
            $NULL

# Setup jenkins.
COPY conf/jenkins/plugins.txt /usr/share/jenkins/ref

COPY script/docker-entrypoint.sh /

# Setup supervisor
RUN mkdir -p /etc/supervisor.d
COPY conf/supervisor/*.ini /etc/supervisor.d/
COPY conf/logrotate/supervisor /etc/logrotate.d/

# Port forwarding target.
EXPOSE 8080 50000

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
