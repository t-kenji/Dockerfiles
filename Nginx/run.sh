#!/bin/bash

NAME=nginx
MOUNT_ROOT=${HOME}/.docker-containers/volumes
MOUNT_CERTS=${MOUNT_ROOT}/certs
MOUNT_POINT=${MOUNT_ROOT}/${NAME}

docker run -d \
           --name ${NAME} \
           -p 80:80 \
           -p 443:443 \
           -p 8089:8089 \
           -p 8989:8989 \
           --link trac:trac \
           --link kallithea:kallithea \
           --link letschat:letschat \
           --link jenkins-master:jenkins \
           --link janus:janus \
           -v ${MOUNT_CERTS}:/usr/share/certs \
           -v ${MOUNT_POINT}/www-data:/usr/share/www-data \
           tkenji/${NAME} \
           $@
