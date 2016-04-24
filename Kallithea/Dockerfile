#
# Dockerfile for Kallithea Container.
#

# Pull base image.
FROM ubuntu:14.04

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV USER=kallithea
ENV HOME=/home/$USER
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'Asia/Tokyo' > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Install packages.
RUN sed -i -e 's/\/\/archive.ubuntu.com/\/\/ftp.jaist.ac.jp/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y python-software-properties \
                       software-properties-common
RUN add-apt-repository -y ppa:git-core/ppa && \
    add-apt-repository -y ppa:mercurial-ppa/releases
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y automake \
                       build-essential \
                       curl \
                       git \
                       git-svn \
                       libpython2.7 \
                       libpython2.7-dev \
                       libsqlite3-dev \
                       libtool \
                       mercurial \
                       pkg-config \
                       python-dev \
                       python-setuptools \
                       python-pip \
                       python-virtualenv \
                       supervisor \
                       vim-nox \
                       wget \
                       zlib1g-dev

# Create user.
RUN useradd -d /home/$USER -m -s /bin/bash $USER && \
    echo "$USER:$USER" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Define working directory.
WORKDIR $HOME

# Setup python.
RUN /bin/echo -e "\
\n\
try:\n\
    import sys\n\
except ImportError:\n\
    pass\n\
else:\n\
    sys.setdefaultencoding('utf-8')\n\
" >> /etc/python2.7/sitecustomize.py

# Install kallithea.
RUN virtualenv --no-site-packages /opt/venv/kallithea
RUN /opt/venv/kallithea/bin/pip install kallithea
#RUN git clone -b improve-hook-extension https://github.com/t-kenji/kallithea-mirror.git
#WORKDIR kallithea-mirror
#RUN /opt/venv/kallithea/bin/pip install .
#RUN python ./setup.py compile_catalog-f
RUN mkdir -p /var/lib/kallithea/repos
RUN /opt/venv/kallithea/bin/paster make-config Kallithea /var/lib/kallithea/production.ini
RUN sed -i 's/host = 127.0.0.1/host = 0.0.0.0/' /var/lib/kallithea/production.ini && \
    sed -i 's/port = 5000/port = 5010/' /var/lib/kallithea/production.ini && \
    sed -i 's/lang =\( en\)*/lang = ja/' /var/lib/kallithea/production.ini
RUN /opt/venv/kallithea/bin/paster setup-db \
                                   /var/lib/kallithea/production.ini \
                                   --user=admin \
                                   --password=admin0 \
                                   --email=admin@email.com \
                                   --repos=/var/lib/kallithea/repos \
                                   --force-yes
RUN chown $USER:$USER -R /var/lib/kallithea

# Install kallithea extension.
RUN /opt/venv/kallithea/bin/paster make-rcext /var/lib/kallithea/production.ini

# Setup supervisord Kallithea processes.
RUN /bin/echo -e "\
[program:kallithea]\n\
command=/opt/venv/kallithea/bin/paster serve /var/lib/kallithea/production.ini\n\
directory=/var/lib/kallithea\n\
user=kallithea\n\
" > /etc/supervisor/conf.d/kallithea.conf

# Port forwarding target.
EXPOSE 5010

# Define default command.
CMD ["/usr/bin/supervisord", "-n"]
