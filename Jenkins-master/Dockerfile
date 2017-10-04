#
# Dockerfile for Jenkins-master Container.
#

# Pull base image.
FROM jenkins:2.60.3-alpine

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
RUN apk add --no-cache --virtual .jenkins-rundeps \
            curl \
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

# Setup jenkins.
COPY conf/jenkins/plugins.txt /usr/share/jenkins/ref
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

# Setup supervisor
RUN mkdir -p /etc/supervisor.d
COPY conf/supervisor/*.ini /etc/supervisor.d/
COPY conf/logrotate/supervisor /etc/logrotate.d/

COPY script/docker-entrypoint.sh /

# Port forwarding target.
EXPOSE 8080

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
