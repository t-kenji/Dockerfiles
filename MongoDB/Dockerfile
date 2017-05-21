#
# Dockerfile for MongoDB Container.
#

# Pull base image.
FROM ubuntu:14.04

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root
ENV DEBIAN_FRONTEND=noninteractive
ENV MONGODATA=/data

# Set data volume.
VOLUME $MONGODATA

# Install packages.
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list && \
    apt-get update && \
    apt-get install -y curl mongodb-org \
    $NULL
RUN apt-get install -y vim

COPY script/docker-entrypoint.sh /

# Define working directory.
WORKDIR $HOME

# Port forwarding target.
EXPOSE 27017

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mongod"]
