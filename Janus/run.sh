#!/bin/bash

NAME=janus
MOUNT_ROOT=${HOME}/.docker-containers/volumes
MOUNT_CERTS=${MOUNT_ROOT}/certs

docker run -d \
           --name ${NAME} \
           -v ${MOUNT_CERTS}:/usr/share/certs \
           tkenji/${NAME} \
           $@
