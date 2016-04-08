#
# Dockerfile for Let's Chat Container.
#

# Pull base image.
FROM ubuntu:14.04

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV USER=letschat \
    HOME=/home/$USER \
    DEBIAN_FRONTEND=noninteractive

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
                       binutils-dev \
                       build-essential \
                       curl \
                       git \
                       git-svn \
                       mercurial \
                       nodejs \
                       npm \
                       vim-nox \
                       wget

# Create user.
RUN useradd -d /home/$USER -m -s /bin/bash $USER && \
    echo "$USER:$USER" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo 'Asia/Tokyo' > /etc/timezone

# Define working directory.
WORKDIR $HOME

# Setup vim.
COPY config/_vimrc $HOME/.vimrc

# Setup Node.js.
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

# Install Let's Chat.
RUN git clone -b custom https://github.com/t-kenji/lets-chat.git
WORKDIR lets-chat
RUN npm install
COPY patches/settings.yml.patch settings.yml.patch
RUN cp settings.yml.sample settings.yml && \
    patch -u settings.yml < settings.yml.patch

# Port forwarding target.
EXPOSE 5000

# Define default command.
CMD ["bash", "-c", "LCB_DATABASE_URI=mongodb://$DB_PORT_27017_TCP_ADDR/letschat npm start"]
