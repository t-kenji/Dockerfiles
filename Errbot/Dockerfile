#
# Dockerfile for Errbot Container.
#

# Pull base image.
FROM python:3.6.0-alpine

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root

RUN apk update

RUN apk add --no-cache \
            gcc \
            g++ \
            libffi-dev \
            openssl-dev \
            $NULL

RUN apk add --no-cache \
            git \
            vim \
            bash \
            $NULL

WORKDIR $HOME

RUN mkdir -p script
COPY script/venv script/venv

RUN pyvenv-3.6 errbot-venv
RUN errbot-venv/bin/pip install errbot socketio-client pytz crontab

ENTRYPOINT ["/bin/bash"]
