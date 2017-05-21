#!/bin/bash

NAME=postgres
MOUNT_POINT=${HOME}/.docker-containers/volumes/${NAME}

docker run -d \
           --name ${NAME} \
           -v ${MOUNT_POINT}/data:/var/lib/postgresql/data \
           tkenji/${NAME} \
           $@
