#!/bin/bash

if [ ! -d $JENKINS_HOME/.ssh ]; then
	mv $HOME/.ssh $JENKINS_HOME
	/usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt
	chown jenkins:jenkins -R $JENKINS_HOME
fi

exec $@
