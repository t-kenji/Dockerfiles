#!/bin/bash

NAME=jenkins-master
MOUNT_POINT=${HOME}/.docker-containers/volumes/${NAME}

docker run -d \
           -ti \
           --name ${NAME} \
           -p 8080:8080 \
           -p 50000:50000 \
           -v ${MOUNT_POINT}/jenkins_home:/var/jenkins_home \
           tkenji/${NAME} \
           $@
