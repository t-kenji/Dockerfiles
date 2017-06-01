#!/bin/bash

NAME=nginx
MOUNT_ROOT=${HOME}/.docker-containers/volumes

docker run -d \
           -ti \
           --name ${NAME} \
           -p 80:80 \
           -p 443:443 \
           --link trac:trac \
           --link kallithea:kallithea \
           --link letschat:letschat \
           --link jenkins-master:jenkins \
           --link janus:janus \
		   -v ${MOUNT_ROOT}/janus/www-data:/usr/share/www-data/janus \
           tkenji/${NAME} \
           $@
