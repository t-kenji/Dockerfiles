#
# Dockerfile for Janus-gateway Container.
#

# Pull base image.
FROM alpine:3.6

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
USER root
ENV HOME=/root
ENV LANG=en_US.utf8

# Install packages.
RUN apk update
RUN apk add --no-cache \
            autoconf \
            automake \
            cmake \
            curl-dev \
            gcc \
            g++ \
            gengetopt \
            git \
            git-svn \
            glib-dev \
            jansson-dev \
            libmicrohttpd-dev \
            libnice-dev \
            libogg-dev \
            libressl-dev \
            libsrtp-dev \
            libtool \
            libwebsockets-dev \
            m4 \
            make \
            opus-dev \
            pkgconf \
            rabbitmq-c-dev \
            $NULL
RUN apk add --no-cache \
            vim \
            bash \
            logrotate \
            supervisor \
            $NULL

# Define working directory.
WORKDIR $HOME

COPY script/docker-entrypoint.sh /

# Setup supervisor
RUN mkdir -p /etc/supervisor.d
COPY conf/supervisor/*.ini /etc/supervisor.d/
COPY conf/logrotate/supervisor /etc/logrotate.d/

# Setup usrsctp.
RUN git clone --depth=1 -b 0.9.3.0 https://github.com/sctplab/usrsctp.git
RUN cd usrsctp && \
    ./bootstrap && \
    ./configure && \
    make install

# Setup paho.mqtt.c.
RUN git clone --depth=1 -b v1.1.0 https://github.com/eclipse/paho.mqtt.c.git
RUN cd paho.mqtt.c && \
    mkdir -p temp && \
    cd temp && \
    cmake -DPAHO_WITH_SSL=TRUE .. && \
    make install

# Setup janus-gateway
RUN git clone --depth=1 -b hotfix/libressl-support https://github.com/t-kenji/janus-gateway.git
RUN cd janus-gateway && \
    ./autogen.sh && \
    ./configure && \
    make install
RUN cd /usr/local/etc/janus && \
    for cfg in `ls *.sample`; do mv ${cfg} ${cfg%.sample}; done

# Port forwarding target.
EXPOSE 8088 8089 8188 8989

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
