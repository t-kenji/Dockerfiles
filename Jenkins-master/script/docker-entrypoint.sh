#!/bin/bash

if [ ! -d $JENKINS_HOME/.ssh ]; then
	mkdir -p $JENKINS_HOME/.ssh
fi
chown jenkins:jenkins -R $JENKINS_HOME
ssh-keyscan -H slave-program-1 >> /var/jenkins_home/.ssh/known_hosts 2>&1

exec "$@"
