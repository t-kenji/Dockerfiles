#
# Dockerfile for QorIQ-SDK Container.
#

# Pull base image.
FROM ubuntu:16.04

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV USER=tkenji
ENV HOME=/home/$USER
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

# Set data volume.
VOLUME $HOME

# Install packages and 1st setup.
RUN sed -e 's/\/\/archive.ubuntu.com/\/\/ftp.jaist.ac.jp/g' -i /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y python-software-properties \
                       software-properties-common \
                       tzdata \
                       $NULL
RUN dpkg --add-architecture i386 \
 && dpkg-reconfigure -p critical dash \
 && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
 && add-apt-repository -y ppa:git-core/ppa \
 && add-apt-repository -y ppa:openjdk-r/ppa \
 && add-apt-repository -y ppa:jonathonf/vim \
 && apt-get update \
 && apt-get upgrade -y

# Install packages and 2nd setup.
RUN apt-get install -y byobu \
                       curl \
                       exuberant-ctags \
                       graphviz \
                       libedit2 \
                       libncurses5 \
                       libpython2.7 \
                       openjdk-8-jre-headless \
                       python-pip \
                       python-pygments \
                       python-setuptools \
                       python-virtualenv \
                       rsync \
                       sqlite3 \
                       sudo \
                       supervisor \
                       unzip \
                       vim-nox \
                       wget \
                       $NULL

# Install packages and 3rd setup.
RUN apt-get install -y build-essential
RUN apt-get install -y automake \
                       bc \
                       binutils-dev \
                       bison \
                       chrpath \
                       cpio \
                       device-tree-compiler \
                       diffstat \
                       flex \
                       gawk \
                       gdb \
                       git \
                       git-core \
                       git-svn \
                       iptables \
                       libcurl4-openssl-dev \
                       libedit-dev \
                       libffi-dev \
                       liblzma-dev \
                       libncurses5-dev \
                       libpcre3-dev \
                       libpython2.7-dev \
                       libreadline-dev \
                       libsdl1.2-dev \
                       libsqlite3-dev \
                       libssl-dev \
                       libtool \
                       libxml2-dev \
                       libxslt1-dev \
                       libyaml-dev \
                       mercurial \
                       parted \
                       pkg-config \
                       python-dev \
                       rpcbind \
                       silversearcher-ag \
                       socat \
                       texinfo \
                       tig \
                       u-boot-tools \
                       zlib1g-dev \
                       $NULL
RUN apt-get install -y gcc-multilib \
                       g++-multilib \
                       libc6:i386 \
                       libncurses5-dev:i386 \
                       libstdc++6:i386 \
                       $NULL

WORKDIR /tmp
RUN mkdir -p /opt/toolchain /opt/analyzer

# Install direnv.
RUN wget -O /usr/bin/direnv https://github.com/direnv/direnv/releases/download/v2.13.1/direnv.linux-amd64 \
 && chmod +x /usr/bin/direnv

# Install global.
RUN curl -L http://tamacom.com/global/global-6.5.7.tar.gz | tar zx \
 && cd global-6.5.7 \
 && ./configure --prefix=/usr \
 && make -j 4 install

# Install LLVM+Clang.
RUN echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main" >> /etc/apt/sources.list.d/llvm-toolchain-xenial.list \
 && echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main" >> /etc/apt/sources.list.d/llvm-toolchain-xenial.list \
 && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
 && apt-get update \
 && apt-get install -y clang-5.0 lldb-5.0 clang-format-5.0

# Install cmake.
RUN curl -L https://cmake.org/files/v3.9/cmake-3.9.4-Linux-x86_64.tar.gz | tar zx \
 && mv cmake-3.9.4-Linux-x86_64 /opt/toolchain/cmake \
 && echo 'PATH="/opt/toolchain/cmake/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh
ENV PATH /opt/toolchain/cmake/bin:$PATH

# Install cpplint.
RUN git clone https://github.com/google/styleguide.git \
 && mv styleguide /opt/analyzer/

# Install GoogleTest
RUN git clone https://github.com/google/googletest.git \
 && cd googletest \
 && mkdir -p build \
 && cd build \
 && cmake -DCMAKE_INSTALL_PREFIX=/opt/toolchain/googletest \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_C_COMPILER=gcc \
          -DCMAKE_CXX_COMPILER=g++ \
          -DBUILD_GTEST=ON \
          .. \
 && make -j 4 \
 && make install

# Install CppUTest.
RUN git clone https://github.com/cpputest/cpputest.git \
 && cd cpputest \
 && mkdir -p cpputest \
 && cd cpputest \
 && cmake -DCMAKE_INSTALL_PREFIX=/opt/toolchain/cpputest -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCOVERAGE=ON .. \
 && make -j 4 \
 && make install

# Install CppCheck.
RUN git clone -b 1.81 https://github.com/danmar/cppcheck.git \
 && cd cppcheck \
 && mkdir build \
 && cd build \
 && cmake -DCMAKE_INSTALL_PREFIX=/opt/analyzer/cppcheck -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_BUILD_TYPE=Release .. \
 && make -j 4 \
 && make install \
 && echo 'PATH="/opt/analyzer/cppcheck/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Install Valgrind.
RUN curl -L ftp://sourceware.org/pub/valgrind/valgrind-3.13.0.tar.bz2 | tar jx \
 && cd valgrind-3.13.0 \
 && ./configure --prefix=/opt/analyzer/valgrind \
 && make -j 4 \
 && make install \
 && echo 'PATH="/opt/analyzer/valgrind/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Setup supervisor.
COPY conf/supervisor/*.conf /etc/supervisor/conf.d/

COPY script/docker-entrypoint.sh /

WORKDIR $HOME

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
