#!/bin/bash

if [ ! -d $JENKINS_HOME/.ssh ]; then
	mv $HOME/.ssh $JENKINS_HOME
	ssh-keyscan -H slave-program-1 >> /var/jenkins_home/.ssh/known_hosts 2>&1
	/usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt
	chown jenkins:jenkins -R $JENKINS_HOME
fi

exec $@
