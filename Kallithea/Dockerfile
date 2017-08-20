#
# Dockerfile for Kallithea Container.
#

# Pull base image.
FROM python:2.7-alpine3.6

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root
ENV LANG=C.UTF-8
ENV RCDATA=/var/lib/kallithea/data
ENV RCREPO=/var/lib/kallithea/repos

# Set data volume.
VOLUME $RCDATA
VOLUME $RCREPO

# Install packages.
RUN apk update
RUN apk add --no-cache --virtual .kallithea-rundeps \
            git \
            libffi \
            logrotate \
            mercurial \
            postgresql-libs \
            postgresql-client \
            supervisor \
            $NULL
RUN apk add --no-cache --virtual .kallithea-builddeps \
            build-base \
            libffi-dev \
            postgresql-dev \
            $NULL
RUN apk add --no-cache \
            vim \
            bash \
            less \
            $NULL

RUN pip install --no-cache-dir \
                virtualenv \
                $NULL

COPY script/docker-entrypoint.sh /

# Define working directory.
WORKDIR $HOME

# Setup kallithea
COPY conf/kallithea/requirements.txt $HOME/
RUN virtualenv --no-site-packages ./venv \
    && ./venv/bin/pip install --upgrade pip \
    && ./venv/bin/pip install -r $HOME/requirements.txt \
    && /bin/echo -e "\
try:\n\
	import sys\n\
except ImportError:\n\
	pass\n\
else:\n\
	sys.setdefaultencoding('utf-8')\n\
" >> ./venv/lib/python2.7/sitecustomize.py
RUN git clone https://github.com/t-kenji/kallithea-rcextensions.git $RCDATA/rcextensions

# Setup supervisor
RUN mkdir -p /etc/supervisor.d
COPY conf/supervisor/*.ini /etc/supervisor.d/
COPY conf/logrotate/supervisor /etc/logrotate.d/

# Port forwarding target.
EXPOSE 5010

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
