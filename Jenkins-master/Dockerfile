#
# Dockerfile for Jenkins-master Container.
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
                       build-essential \
                       curl \
                       git \
                       git-svn \
                       mercurial \
                       openjdk-8-jre-headless \
                       openssh-server \
                       supervisor \
                       vim-nox \
                       wget

# Create user.
RUN useradd -d $HOME -m -s /bin/bash $USER && \
    echo "$USER:$USER" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
COPY config/ssh $HOME/.ssh
RUN chown $USER:$USER -R $HOME/.ssh

# Install Jenkins-master.
#ADD http://mirrors.jenkins-ci.org/war/latest/jenkins.war /opt/jenkins/lib/jenkins.war
COPY packages/jenkins.war /opt/jenkins/lib/jenkins.war
RUN chmod 644 /opt/jenkins/lib/jenkins.war
ENV JENKINS_HOME /var/lib/jenkins
#ADD https://updates.jenkins-ci.org/latest/scm-api.hpi /var/lib/jenkins/plugins/
#COPY packages/scm-api.hpi /var/lib/jenkins/plugins/
#ADD https://updates.jenkins-ci.org/latest/git-client.hpi /var/lib/jenkins/plugins/
#COPY packages/git-client.hpi /var/lib/jenkins/plugins/
#ADD https://updates.jenkins-ci.org/latest/git.hpi /var/lib/jenkins/plugins/
#COPY packages/git.hpi /var/lib/jenkins/plugins/
#ADD https://updates.jenkins-ci.org/latest/ansicolor.hpi /var/lib/jenkins/plugins/
#COPY packages/ansicolor.hpi /var/lib/jenkins/plugins/

# Setup supervisord Jenkins processes.
RUN /bin/echo -e "\
[program:jenkins-master]\n\
command=/usr/bin/java -Dfile.encoding=UTF-8 -jar /opt/jenkins/lib/jenkins.war\n\
process_name=%(program_name)s_%(process_num)04d\n\
numprocs=1\n\
numprocs_start=8080\n\
redirect_stderr=true\n\
stdout_logfile=/%(here)s/jenkins.log\n\
stopsignal=QUIT\n\
autostart=true\n\
autorestart=true\n\
" > /etc/supervisor/conf.d/jenkins-master.conf

# Port forwarding target.
EXPOSE 8080

# Define default command.
CMD ["/usr/bin/supervisord", "-n"]
