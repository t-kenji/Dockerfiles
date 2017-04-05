#
# Dockerfile for Kallithea Container.
#

# Pull base image.
FROM python:2.7-alpine

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root

# Install packages.
RUN apk update
RUN apk add --no-cache \
            curl \
            gcc \
            g++ \
            git \
            git-svn \
            libffi-dev \
            mercurial \
            postgresql-dev \
            $NULL
RUN apk add --no-cache \
            vim \
            bash \
            $NULL

# Workaround for pyparsing install error.
# http://stackoverflow.com/questions/42029545/pip-is-error-typeerror-call-takes-exactly-2-arguments-1-given
RUN pip install --upgrade \
                --no-cache-dir \
                setuptools==33.1.1 \
                $NULL

RUN pip install --no-cache-dir \
                psycopg2 \
                supervisor \
                virtualenv \
                $NULL

# Define working directory.
WORKDIR $HOME

COPY script/entrypoint.sh /

# Port forwarding target.
EXPOSE 5010

# Define default command.
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
