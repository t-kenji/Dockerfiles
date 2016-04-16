#
# Dockerfile for Jenkins-slave Container.
#

# Pull base image.
FROM ubuntu:14.04

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV USER=jenkins
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
    add-apt-repository -y ppa:mercurial-ppa/releases && \
    add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y automake \
                       binutils-dev \
                       build-essential \
                       curl \
                       git \
                       git-svn \
                       graphviz \
                       haskell-platform \
                       libcurl4-openssl-dev \
                       libedit2 \
                       libedit-dev \
                       libffi-dev \
                       liblzma-dev \
                       libncurses5-dev \
                       libpcre3-dev \
                       libpython2.7 \
                       libpython2.7-dev \
                       libreadline-dev \
                       libsqlite3-dev \
                       libssl-dev \
                       libtool \
                       libxml2-dev \
                       libxslt1-dev \
                       libyaml-dev \
                       mercurial \
                       openjdk-8-jre-headless \
                       openssh-server \
                       pkg-config \
                       python-dev \
                       python-setuptools \
                       python-pip \
                       python-virtualenv \
                       sqlite3 \
                       swig \
                       unzip \
                       vim-nox \
                       wget \
                       zlib1g-dev

# Create user.
RUN useradd -d $HOME -m -s /bin/bash $USER && \
    echo "$USER:$USER" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
COPY config/ssh $HOME/.ssh
RUN chown $USER:$USER -R $HOME/.ssh

# Setup jenkins-slave.
RUN mkdir /var/lib/jenkins && \
    chown $USER:$USER /var/lib/jenkins

# Setup sshd.
RUN sed -i -e 's/#AuthorizedKeysFile/AuthorizedKeysFile/g' /etc/ssh/sshd_config
RUN sed -i -e 's/#PasswordAuthentication\s+yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd

# Install cmake.
WORKDIR $HOME
RUN curl -L https://cmake.org/files/v3.5/cmake-3.5.1-Linux-x86_64.tar.gz | tar zx && \
    mkdir -p /opt/toolchain && \
    cp -af cmake-3.5.1-Linux-x86_64 /opt/toolchain/cmake && \
    echo 'PATH="/opt/toolchain/cmake/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh
ENV PATH /opt/toolchain/cmake/bin:$PATH

# Install ag.
RUN git clone https://github.com/ggreer/the_silver_searcher.git && \
    cd the_silver_searcher && \
    ./build.sh && \
    make install

# Install LLVM+Clang.
RUN git clone http://llvm.org/git/llvm.git && \
    cd llvm && \
    (cd tools && git clone http://llvm.org/git/clang.git) && \
    (cd projects && git clone http://llvm.org/git/libcxx) && \
    (cd projects && git clone http://llvm.org/git/libcxxabi) && \
    (cd projects && git clone http://llvm.org/git/compiler-rt) && \
    (cd tools && git clone http://llvm.org/git/lldb) && \
    (cd tools && git clone http://llvm.org/git/lld) && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/toolchain/llvm+clang -DCMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_CXX_COMPILER=/usr/bin/g++ .. && \
    make -j 4 && \
    make install && \
    echo 'PATH="/opt/toolchain/llvm+clang/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Install cpplint.
RUN git clone https://github.com/google/styleguide.git && \
    mv styleguide /opt/analyzer/

# Install CppUTest.
RUN git clone https://github.com/cpputest/cpputest.git && \
    cd cpputest && \
    mkdir cpputest && \
    cd cpputest && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/toolchain/cpputest -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCOVERAGE=ON .. && \
    make -j 4 && \
    make install

# Install CppCheck.
RUN git clone https://github.com/danmar/cppcheck.git && \
    cd cppcheck && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/analyzer/cppcheck -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_BUILD_TYPE=Release .. && \
    make -j 4 && \
    make install && \
    echo '/opt/analyzer/cppcheck/lib' > /etc/ld.so.conf.d/cppcheck.conf && \
    ldconfig && \
    echo 'PATH="/opt/analyzer/cppcheck/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Install Valgrind.
RUN curl -L http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2 | tar jx && \
    cd valgrind-3.11.0 && \
    ./configure --prefix=/opt/analyzer/valgrind && \
    make -j 4 && \
    make install && \
    echo 'PATH="/opt/analyzer/valgrind/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Install ruby.
RUN git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv && \
    git clone git://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build && \
    git clone git://github.com/sstephenson/rbenv-gem-rehash.git $HOME/.rbenv/plugins/rbenv-gem-rehash
RUN echo 'PATH="$HOME/.rbenv/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh && \
    echo 'eval "$(rbenv init -)"' >> /etc/profile.d/Z99-tools.sh && \
    echo 'PATH="$HOME/.rvenv/plugins/ruby-build/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh
RUN $HOME/.rbenv/bin/rbenv install 2.3.0 && \
    $HOME/.rbenv/bin/rbenv global 2.3.0 && \
    chown $USER:$USER -R $HOME/.rbenv

# Install bugspots.
RUN $HOME/.rbenv/shims/gem install bugspots

# Port forwarding target.
EXPOSE 22

# Define default command.
CMD ["/usr/sbin/sshd", "-D"]
