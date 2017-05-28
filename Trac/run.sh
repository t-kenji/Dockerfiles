#!/bin/bash

NAME=trac
MOUNT_POINT=${HOME}/.docker-containers/volumes/${NAME}

docker run -d \
           --name ${NAME} \
           -p 8001:8001 \
           -v ${MOUNT_POINT}/data:/var/lib/trac \
           tkenji/${NAME} \
           $@
