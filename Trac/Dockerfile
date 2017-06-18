#
# Dockerfile for Trac Container.
#

# Pull base image.
FROM python:2.7-alpine3.6

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root
ENV LANG=C.UTF-8
ENV TRACDATA=/var/lib/trac

# Set data volume.
VOLUME $TRACDATA

# Install packages.
RUN apk add --no-cache \
            cairo-dev \
            curl \
            gcc \
            g++ \
            git \
            git-svn \
            libffi-dev \
            libjpeg-turbo-dev \
            libpng-dev \
            logrotate \
            mercurial \
            postgresql-dev \
            sqlite-dev \
            supervisor \
            zlib-dev \
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

# Setup trac.
COPY script/bootstrap.py $HOME/
COPY conf/trac/trac.ini.template $HOME/
COPY conf/trac/requirements.txt $HOME/
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
    ./venv/bin/pip install setuptools==33.1.1 && \
    ./venv/bin/pip install -r requirements.txt

# Setup supervisor
RUN mkdir -p /etc/supervisor.d
COPY conf/logrotate/supervisor /etc/logrotate.d/

COPY script/docker-entrypoint.sh /

# Expose port.
EXPOSE 8001-8009

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
