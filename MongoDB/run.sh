#!/bin/bash

NAME=mongodb
MOUNT_POINT=${HOME}/.docker-containers/volumes/${NAME}

docker run -d \
           --name ${NAME} \
           -v ${MOUNT_POINT}/data:/data \
           tkenji/${NAME} \
           $@
