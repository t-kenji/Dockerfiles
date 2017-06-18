#
# Dockerfile for Jenkins-slave Container.
#

# Pull base image.
FROM ubuntu:14.04

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV USER=buildbot
ENV HOME=/home/$USER
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'Asia/Tokyo' > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Install packages.
RUN sed -i -e 's/\/\/archive.ubuntu.com/\/\/ftp.jaist.ac.jp/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y python-software-properties \
                       software-properties-common
RUN add-apt-repository -y ppa:git-core/ppa && \
    dpkg --add-architecture i386
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y automake \
                       binutils-dev \
                       build-essential \
                       curl \
                       gcc-multilib \
                       git \
                       git-svn \
                       graphviz \
                       g++-multilib \
                       libc6:i386 \
                       libcurl4-openssl-dev \
                       libedit2 \
                       libedit-dev \
                       libffi-dev \
                       liblzma-dev \
                       libncurses5-dev \
                       libncurses5:i386 \
                       libpcre3-dev \
                       libpython2.7 \
                       libpython2.7-dev \
                       libreadline-dev \
                       libsqlite3-dev \
                       libssl-dev \
                       libstdc++6:i386 \
                       libtool \
                       libxml2-dev \
                       libxslt1-dev \
                       libyaml-dev \
                       mercurial \
                       pkg-config \
                       python-dev \
                       python-setuptools \
                       python-pip \
                       python-virtualenv \
                       sqlite3 \
                       supervisor \
                       swig \
                       unzip \
                       vim-nox \
                       wget \
                       zlib1g-dev \
                       $NULL

# Create user.
RUN useradd -d $HOME -m -s /bin/bash $USER && \
    echo "$USER:$USER" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR $HOME
RUN mkdir -p /opt/toolchain /opt/analyzer

# Install cmake.
RUN curl -L https://cmake.org/files/v3.8/cmake-3.8.1-Linux-x86_64.tar.gz | tar zx && \
    mv cmake-3.8.1-Linux-x86_64 /opt/toolchain/cmake && \
    echo 'PATH="/opt/toolchain/cmake/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh
ENV PATH /opt/toolchain/cmake/bin:$PATH

# Install LLVM+Clang.
RUN curl -L http://releases.llvm.org/4.0.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz | tar Jx && \
    mv clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-14.04 /opt/toolchain/llvm+clang && \
    find /opt/toolchain/llvm+clang -type d | xargs chmod +rx && \
    chown root:root -R /opt/toolchain/llvm+clang && \
    echo 'PATH="/opt/toolchain/llvm+clang/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Install cpplint.
RUN git clone https://github.com/google/styleguide.git && \
    mv styleguide /opt/analyzer/

# Install GoogleTest
RUN git clone https://github.com/google/googletest.git && \
    cd googletest && \
    mkdir -p build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/toolchain/googletest \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_C_COMPILER=gcc \
          -DCMAKE_CXX_COMPILER=g++ \
          -DBUILD_GTEST=ON \
          .. && \
    make -j 4 && \
    make install

# Install CppUTest.
RUN git clone https://github.com/cpputest/cpputest.git && \
    cd cpputest && \
    mkdir -p cpputest && \
    cd cpputest && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/toolchain/cpputest -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCOVERAGE=ON .. && \
    make -j 4 && \
    make install

# Install CppCheck.
RUN git clone -b 1.79 https://github.com/danmar/cppcheck.git && \
    cd cppcheck && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/analyzer/cppcheck -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_BUILD_TYPE=Release .. && \
    make -j 4 && \
    make install && \
    echo 'PATH="/opt/analyzer/cppcheck/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Install Valgrind.
RUN curl -L http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2 | tar jx && \
    cd valgrind-3.11.0 && \
    ./configure --prefix=/opt/analyzer/valgrind && \
    make -j 4 && \
    make install && \
    echo 'PATH="/opt/analyzer/valgrind/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Setup buildbot-worker.
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
    ./venv/bin/pip install buildbot-worker
RUN ./venv/bin/buildbot-worker create-worker ~/worker master:9989 $BUILDER_NAME $BUILDER_PASS

# Setup supervisor
COPY conf/supervisor/*.conf /etc/supervisor/conf.d/
COPY conf/logrotate/supervisor /etc/logrotate.d/

COPY script/docker-entrypoint.sh /

# Define default command.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
