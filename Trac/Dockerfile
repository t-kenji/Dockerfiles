#
# Dockerfile for Trac Container.
#

# Pull base image.
FROM ubuntu:14.04

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV USER=trac
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
                       vim-nox \
                       wget

# Create user.
RUN useradd -d /home/$USER -m -s /bin/bash $USER && \
    echo "$USER:$USER" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Define working directory.
WORKDIR $HOME

# Setup vim.
COPY config/_vimrc $HOME/.vimrc

# Install trac.
RUN git clone https://github.com/t-kenji/trac.git && \
    virtualenv --no-site-packages /opt/venv/trac
RUN /opt/venv/trac/bin/pip install Genshi && \
    /opt/venv/trac/bin/pip install pysqlite && \
    /opt/venv/trac/bin/pip install Babel && \
    /opt/venv/trac/bin/pip install docutils && \
    /opt/venv/trac/bin/pip install Pygments&& \
    /opt/venv/trac/bin/pip install pytz && \
    /opt/venv/trac/bin/pip install ./trac
RUN /opt/venv/trac/bin/pip install requests && \
    /opt/venv/trac/bin/pip install CherryPy
RUN mkdir -p /var/lib/trac/sites && \
    mkdir -p /var/lib/trac/deploy
COPY scripts/trac-cherry.py ./

# Install trac plugins.
RUN git clone https://github.com/t-kenji/trac-account-manager-plugin.git && \
    git clone https://github.com/t-kenji/trac-tags-plugin.git && \
    git clone https://github.com/t-kenji/trac-sectionedit-plugin.git && \
    git clone https://github.com/t-kenji/trac-exceldownload-plugin.git && \
    git clone https://github.com/t-kenji/trac-sensitivetickets-plugin.git && \
    git clone https://github.com/t-kenji/trac-privatetickets-plugin.git && \
    git clone https://github.com/t-kenji/trac-themeengine-plugin.git && \
    git clone https://github.com/t-kenji/trac-bootstrap-theme.git
RUN /opt/venv/trac/bin/pip install ./trac-account-manager-plugin && \
    /opt/venv/trac/bin/pip install ./trac-tags-plugin && \
    /opt/venv/trac/bin/pip install ./trac-sectionedit-plugin && \
    /opt/venv/trac/bin/pip install ./trac-exceldownload-plugin && \
    /opt/venv/trac/bin/pip install ./trac-sensitivetickets-plugin && \
    /opt/venv/trac/bin/pip install ./trac-privatetickets-plugin && \
    /opt/venv/trac/bin/pip install ./trac-themeengine-plugin && \
    /opt/venv/trac/bin/pip install ./trac-bootstrap-theme

# Expose port.
EXPOSE 8000

# Define default command.
CMD ["/bin/bash"]
