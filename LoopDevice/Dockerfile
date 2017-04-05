#
# Dockerfile for Playground Container.
#

# Pull base image.
FROM ubuntu:14.04

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV USER=loop
ENV HOME=/home/$USER
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'Asia/Tokyo' > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Create user.
RUN useradd -d $HOME -m -s /bin/bash $USER && \
    echo "$USER:$USER" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo 'LANG="ja_JP.UTF-8"' > /etc/default/local && \
    locale-gen ja_JP.UTF-8 && \
    dpkg-reconfigure locales

# Define working directory.
WORKDIR $HOME

# Define default command.
CMD ["/bin/bash"]
