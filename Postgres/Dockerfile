#
# Dockerfile for Postgres Container.
#

# Pull base image.
FROM postgres:9.6-alpine

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root
ENV LANG=en_US.utf8
ENV PGDATA=/var/lib/postgresql/data

# Set data volume.
VOLUME $PGDATA

# Install packages.
RUN apk update
RUN apk add --no-cache \
            vim \
            bash \
            $NULL

# Define working directory.
WORKDIR $HOME

# Setup postgres
COPY script/initdb.d/*.sh /docker-entrypoint-initdb.d/

# Port forwarding target.
EXPOSE 5432

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["postgres"]
