#
# Dockerfile for Janus-Gateway Container.
#

# Pull base image.
FROM ubuntu:16.04

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV HOME=/root
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install packages.
RUN sed -e 's/\/\/archive.ubuntu.com/\/\/ftp.jaist.ac.jp/g' -i /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y python-software-properties \
                       software-properties-common
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y curl \
                       git \
                       build-essential \
                       automake \
                       cmake \
                       gengetopt \
                       libmicrohttpd-dev \
                       libjansson-dev \
                       libnice-dev \
                       libssl-dev \
                       libsofia-sip-ua-dev \
                       libglib2.0-dev \
                       libogg-dev \
                       libcurl4-openssl-dev \
                       libtool \
                       logrotate \
                       openssl \
                       pkg-config \
                       supervisor \
                       $NULL
RUN apt-get install -y vim

# Define working directory.
WORKDIR $HOME

# Setup janus-gateway.
RUN git clone --depth=1 -b v1.2.1 https://github.com/xiph/opus.git \
 && cd opus \
 && ./autogen.sh \
 && ./configure --prefix=/usr \
 && make install
RUN git clone --depth=1 -b v2.1.0 https://github.com/cisco/libsrtp.git \
 && cd libsrtp \
 && ./configure --prefix=/usr --enable-openssl \
 && make shared_library install
RUN git clone --depth=1 https://github.com/sctplab/usrsctp \
 && cd usrsctp \
 && mkdir workbench \
 && cd workbench \
 && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. \
 && cmake --build . --target install
RUN git clone --depth=1 -b v2.4.1 https://github.com/warmcat/libwebsockets.git \
 && cd libwebsockets \
 && mkdir workbench \
 && cd workbench \
 && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" .. \
 && cmake --build . --target install
RUN git clone --depth=1 -b v1.2.0 https://github.com/eclipse/paho.mqtt.c.git \
 && cd paho.mqtt.c \
 && mkdir workbench \
 && cd workbench \
 && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DPAHO_WITH_SSL=TRUE .. \
 && cmake --build . --target install
RUN git clone --depth=1 -b v0.8.0 https://github.com/alanxz/rabbitmq-c.git \
 && cd rabbitmq-c \
 && mkdir workbench \
 && cd workbench \
 && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. \
 && cmake --build . --config Release --target install
RUN git clone --depth=1 -b v0.2.6 https://github.com/meetecho/janus-gateway.git \
 && cd janus-gateway \
 && ./autogen.sh \
 && LIBS="-lpthread" ./configure --prefix=/usr \
 && make install \
 && make configs
COPY conf/janus/*.cfg /usr/etc/janus/

# Setup supervisor
COPY conf/supervisor/*.conf /etc/supervisor/conf.d/
COPY conf/logrotate/supervisor /etc/logrotate.d/

COPY script/docker-entrypoint.sh /

# Port forwarding target.
EXPOSE 8088 8089 8188 8989

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
