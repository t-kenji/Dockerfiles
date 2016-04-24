#
# Dockerfile for Embryo Container.
#

# Pull base image.
FROM ubuntu:14.04

# Author.
MAINTAINER tkenji <protect.2501@gmail.com>

# Set environment variables.
ENV USER=embryo
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
    add-apt-repository -y ppa:webupd8team/java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y automake \
                       binutils-dev \
                       build-essential \
                       byobu \
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
                       openssh-server \
                       oracle-java8-installer \
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
                       wget\
                       zlib1g-dev
RUN curl -Lo /tmp/subversion_installer.sh http://opensource.wandisco.com/1.9/scripts/subversion_installer_1.9.sh && \
    echo yn | bash /tmp/subversion_installer.sh && \
    rm /tmp/subversion_installer.sh
RUN update-java-alternatives -s java-8-oracle

# Create user.
RUN useradd -d $HOME -m -s /bin/bash $USER && \
    echo "$USER:$USER" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo 'LANG="ja_JP.UTF-8"' > /etc/default/local && \
    locale-gen ja_JP.UTF-8 && \
    dpkg-reconfigure locales

# Setup sshd.
RUN sed -i -e '/^UsePAM\s+yes/d' /etc/ssh/sshd_config && \
    mkdir -p /var/run/sshd && \
    /etc/init.d/ssh start && /etc/init.d/ssh stop && \
    sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd

# Define working directory.
WORKDIR $HOME

# Setup vim.
COPY config/_vimrc $HOME/.vimrc

# Install cmake.
WORKDIR /tmp
RUN curl -L https://cmake.org/files/v3.5/cmake-3.5.1-Linux-x86_64.tar.gz | tar zx && \
    mkdir -p /opt/toolchain && \
    cp -af cmake-3.5.1-Linux-x86_64 /opt/toolchain/cmake && \
    echo 'PATH="/opt/toolchain/cmake/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh
ENV PATH /opt/toolchain/cmake/bin:$PATH

# Install pandoc.
RUN mkdir -p $HOME/pandoc
WORKDIR $HOME/pandoc
RUN cabal update && \
    cabal install Cabal cabal-install && \
    $HOME/.cabal/bin/cabal sandbox init && \
    $HOME/.cabal/bin/cabal install pandoc && \
    chown $USER:$USER -R $HOME/.ghc $HOME/.cabal
RUN cp $HOME/pandoc/.cabal-sandbox/bin/pandoc $HOME/.cabal/bin && \
    rm -rf $HOME/pandoc && \
    echo 'PATH="~/.cabal/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Install ruby.
WORKDIR $HOME
RUN git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv && \
    git clone git://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build && \
    git clone git://github.com/sstephenson/rbenv-gem-rehash.git $HOME/.rbenv/plugins/rbenv-gem-rehash
RUN echo 'PATH="$HOME/.rbenv/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh && \
    echo 'eval "$(rbenv init -)"' >> /etc/profile.d/Z99-tools.sh && \
    echo 'PATH="$HOME/.rvenv/plugins/ruby-build/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh
RUN $HOME/.rbenv/bin/rbenv install 2.2.3 && \
    $HOME/.rbenv/bin/rbenv global 2.2.3 && \
    chown $USER:$USER -R $HOME/.rbenv

# Install asciidoctor.
WORKDIR $HOME
RUN $HOME/.rbenv/shims/gem install asciidoctor && \
    $HOME/.rbenv/shims/gem install --no-ri --no-rdoc asciidoctor-diagram && \
    $HOME/.rbenv/shims/gem install --no-ri --no-rdoc coderay pygments.rb thread_safe

# Install texlive.
WORKDIR $HOME
COPY package/texlive-local_2015-1_all.deb /tmp/
RUN bash -c 'curl -L https://raw.githubusercontent.com/scottkosty/install-tl-ubuntu/master/install-tl-ubuntu | bash'
RUN dpkg -i /tmp/texlive-local_2015-1_all.deb && \
    echo 'PATH="/usr/local/texlive/2015/bin/x86_64-linux:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Install sphinx.
WORKDIR $HOME
RUN pip install sphinx

# Install doxygen.
WORKDIR /tmp
RUN curl -L ftp://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.11.linux.bin.tar.gz | tar zx && \
    cd doxygen-1.8.11 && \
    sed -i '/doxytag/d' Makefile.in && \
    sed -i '/examples/d' Makefile.in && \
    ./configure --prefix /opt/toolchain/doxygen && \
    make install && \
    echo 'PATH="/opt/toolchain/doxygen/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Install redpen.
WORKDIR /tmp
RUN curl -L https://github.com/redpen-cc/redpen/releases/download/redpen-1.5.3/redpen-1.5.3.tar.gz | tar zx && \
    mkdir -p /opt/analyzer && \
    cp -af redpen-distribution-1.5.3 /opt/analyzer/redpen && \
    echo 'PATH="/opt/analyzer/redpen/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh && \
    echo 'export JAVA_HOME="/usr/lib/jvm/java-8-oracle/jre"' >> /etc/profile.d/Z99-tools.sh

# Install ag.
WORKDIR /tmp
RUN git clone https://github.com/ggreer/the_silver_searcher.git && \
    cd the_silver_searcher && \
    ./build.sh && \
    make install

# Install LLVM+Clang.
WORKDIR /tmp
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
WORKDIR /tmp
RUN git clone https://github.com/google/styleguide.git && \
    mv styleguide /opt/analyzer/

# Install CppUTest.
WORKDIR /tmp
RUN git clone https://github.com/cpputest/cpputest.git && \
    cd cpputest && \
    mkdir cpputest && \
    cd cpputest && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/toolchain/cpputest -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCOVERAGE=ON .. && \
    make -j 4 && \
    make install

# Install CppCheck.
WORKDIR /tmp
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
WORKDIR /tmp
RUN curl -L http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2 | tar jx && \
    cd valgrind-3.11.0 && \
    ./configure --prefix=/opt/analyzer/valgrind && \
    make -j 4 && \
    make install && \
    echo 'PATH="/opt/analyzer/valgrind/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Install bugspots.
WORKDIR /tmp
RUN $HOME/.rbenv/shims/gem install bugspots

# Port forwarding target.
EXPOSE 22

# Define default command.
CMD ["/usr/sbin/sshd", "-D"]
