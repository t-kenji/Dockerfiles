#!/bin/bash

NAME=jenkins-slave-program
MOUNT_POINT=${HOME}/.docker-containers/volumes/${NAME}-1

docker run -d \
           --name ${NAME}-1 \
           -v ${MOUNT_POINT}/ssh:/home/jenkins/.ssh \
           tkenji/${NAME} \
           $@
