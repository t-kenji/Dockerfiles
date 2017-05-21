#!/bin/bash

NAME=kallithea
MOUNT_POINT=${HOME}/.docker-containers/volumes/${NAME}

docker run -d \
           --name ${NAME} \
           -p 5010:5010 \
           --link postgres:db \
           -v ${MOUNT_POINT}/data:/var/lib/kallithea/data \
           tkenji/${NAME} \
           $@
