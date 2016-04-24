#
# Dockerfile for Katana Container.
#

# Pull base image.
FROM ubuntu:14.04

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV USER=katana
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
                       libaprutil1 \
                       libmysqlclient-dev \
                       libpython2.7 \
                       libpython2.7-dev \
                       libsasl2-dev \
                       libldap2-dev \
                       mercurial \
                       python-dev \
                       python-setuptools \
                       python-pip \
                       python-virtualenv \
                       supervisor \
                       vim-nox \
                       wget

# Create user.
RUN useradd -d $HOME -m -s /bin/bash $USER && \
    echo "$USER:$USER" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Define working directory.
WORKDIR $HOME

# Install Buildbot.
RUN pwd && ls && echo $HOME
RUN virtualenv --no-site-packages /opt/venv/buildbot && \
    /opt/venv/buildbot/bin/pip install --upgrade pip && \
    /opt/venv/buildbot/bin/pip install sqlalchemy-migrate==0.7.2 && \
    /opt/venv/buildbot/bin/pip install sqlalchemy==0.7.9 && \
    /opt/venv/buildbot/bin/pip install python-ldap && \
    /opt/venv/buildbot/bin/pip install buildbot && \
    /opt/venv/buildbot/bin/pip install buildbot_slave && \
    /opt/venv/buildbot/bin/pip install mock && \
    /opt/venv/buildbot/bin/pip install sphinx && \
    /opt/venv/buildbot/bin/pip install pyflakes

# Install Katana.
RUN echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session
RUN git clone https://github.com/t-kenji/katana.git
WORKDIR katana
RUN /opt/venv/buildbot/bin/pip install -e master
RUN mkdir -p /var/lib/buildbot
WORKDIR /var/lib/buildbot
RUN /opt/venv/buildbot/bin/buildbot create-master master && \
    cp -a master/master.cfg.sample master/master.cfg
RUN /opt/venv/buildbot/bin/buildslave create-slave slave localhost:9989 example-slave pass
RUN chown $USER:$USER -R /var/lib/buildbot

# Setup supervisord Katana processes.
RUN /bin/echo -e "\
[program:buildmaster]\n\
command=/opt/venv/buildbot/bin/twistd --nodaemon --no_save -y buildbot.tac\n\
directory=/var/lib/buildbot/master\n\
user=katana\n\
\n\
[program:buildslave]\n\
command=/opt/venv/buildbot/bin/twistd --nodaemon --no_save -y buildbot.tac\n\
directory=/var/lib/buildbot/slave\n\
user=katana\n\
" > /etc/supervisor/conf.d/buildbot.conf

# Port forwarding target.
EXPOSE 8010

# Define default command.
CMD ["/usr/bin/supervisord", "-n"]
