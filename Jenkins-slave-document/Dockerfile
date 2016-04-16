#
# Dockerfile for Embryo Container.
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

# Install pandoc.
ADD https://github.com/jgm/pandoc/releases/download/1.17.0.2/pandoc-1.17.0.2-1-amd64.deb /tmp/pandoc-latest.deb
RUN bash -c "ar p /tmp/pandoc-latest.deb data.tar.gz | sudo tar xvz --strip-components 2 -C /usr/local"

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

# Install asciidoctor.
RUN $HOME/.rbenv/shims/gem install asciidoctor && \
    $HOME/.rbenv/shims/gem install --no-ri --no-rdoc asciidoctor-diagram && \
    $HOME/.rbenv/shims/gem install --no-ri --no-rdoc coderay pygments.rb thread_safe

# Install texlive.
COPY packages/texlive-local_2015-1_all.deb /tmp/
RUN bash -c 'curl -L https://raw.githubusercontent.com/scottkosty/install-tl-ubuntu/master/install-tl-ubuntu | bash'
RUN dpkg -i /tmp/texlive-local_2015-1_all.deb && \
    echo 'PATH="/usr/local/texlive/2015/bin/x86_64-linux:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Install sphinx.
RUN virtualenv --no-site-packages /opt/venv/sphinx
RUN /opt/venv/sphinx/bin/pip install sphinx

# Install doxygen.
RUN curl -L ftp://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.11.linux.bin.tar.gz | tar zx && \
    cd doxygen-1.8.11 && \
    sed -i '/doxytag/d' Makefile.in && \
    sed -i '/examples/d' Makefile.in && \
    ./configure --prefix /opt/toolchain/doxygen && \
    make install && \
    echo 'PATH="/opt/toolchain/doxygen/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh

# Install redpen.
RUN curl -L https://github.com/redpen-cc/redpen/releases/download/redpen-1.5.5/redpen-1.5.5.tar.gz | tar zx && \
    mkdir -p /opt/analyzer && \
    cp -af redpen-distribution-1.5.5 /opt/analyzer/redpen && \
    echo 'PATH="/opt/analyzer/redpen/bin:$PATH"' >> /etc/profile.d/Z99-tools.sh && \
    echo 'export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre"' >> /etc/profile.d/Z99-tools.sh

# Port forwarding target.
EXPOSE 22

# Define default command.
CMD ["/usr/sbin/sshd", "-D"]
