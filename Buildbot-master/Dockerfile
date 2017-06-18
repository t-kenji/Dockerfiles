#
# Dockerfile for Buildbot-master Container.
#

# Pull base image.
FROM python:2.7-alpine3.6

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
USER root
ENV HOME=/root
ENV LANG=C.UTF-8
ENV BBDATA=/var/lib/buildbot

# Set data volume.
VOLUME $BBDATA

# Install packages.
RUN apk update
RUN apk add --no-cache \
            curl \
            gcc \
            g++ \
            git \
            git-svn \
            libffi-dev \
            logrotate \
            postgresql-dev \
            sqlite-dev \
            supervisor \
            subversion \
            tzdata \
            $NULL
RUN apk add --no-cache \
            vim \
            bash \
            $NULL

RUN pip install --no-cache-dir \
                virtualenv \
                $NULL

# Define working directory.
WORKDIR $HOME

# Setup buildbot-master.
COPY conf/buildbot/requirements.txt $HOME/
RUN virtualenv --no-site-packages ./venv && \
    /bin/echo -e "\
try:\n\
    import sys\n\
except ImportError:\n\
    pass\n\
else:\n\
    sys.setdefaultencoding('utf-8')\n\
" >> ./venv/lib/python2.7/sitecustomize.py && \
    ./venv/bin/pip install --upgrade pip && \
    ./venv/bin/pip install -r requirements.txt

# Setup supervisor
RUN mkdir -p /etc/supervisor.d
COPY conf/supervisor/*.ini /etc/supervisor.d/
COPY conf/logrotate/supervisor /etc/logrotate.d/

COPY script/docker-entrypoint.sh /

# Port forwarding target.
EXPOSE 8010 9989

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
