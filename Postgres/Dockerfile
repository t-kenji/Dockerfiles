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

VOLUME /var/lib/postgresql/data

RUN apk update

RUN apk add --no-cache \
            vim \
            bash \
            $NULL

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432

CMD ["postgres"]
