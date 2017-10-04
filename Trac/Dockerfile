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
RUN apk update
RUN apk add --no-cache --virtual .trac-rundeps \
            cairo \
            libffi \
            libjpeg-turbo \
            libpng \
            logrotate \
            postgresql-libs \
            sqlite \
            supervisor \
            tzdata \
            zlib \
            $NULL
RUN apk add --no-cache --virtual .trac-builddeps \
            build-base \
            cairo-dev \
            git \
            libffi-dev \
            libjpeg-turbo-dev \
            libpng-dev \
            postgresql-dev \
            sqlite-dev \
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

# Setup timezone.
RUN rm /etc/localtime \
 && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
 && echo "Asia/Tokyo" > /etc/timezone

# Setup trac.
COPY script/bootstrap.py $HOME/
COPY conf/trac/trac.ini.template $HOME/
COPY conf/trac/requirements.txt $HOME/
RUN virtualenv --no-site-packages ./venv \
 && ./venv/bin/pip install --upgrade pip \
 && ./venv/bin/pip install setuptools==33.1.1 \
 && ./venv/bin/pip install -r $HOME/requirements.txt \
 && /bin/echo -e "\
try:\n\
    import sys\n\
except ImportError:\n\
    pass\n\
else:\n\
    sys.setdefaultencoding('utf-8')\n\
" >> ./venv/lib/python2.7/sitecustomize.py

# Setup supervisor
RUN mkdir -p /etc/supervisor.d
COPY conf/logrotate/supervisor /etc/logrotate.d/

COPY script/docker-entrypoint.sh /

# Expose port.
EXPOSE 8001-8009

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
