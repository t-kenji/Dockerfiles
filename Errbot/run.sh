#!/bin/bash

NAME=errbot
MOUNT_POINT=${HOME}/.docker-containers/volumes/${NAME}

docker run -d \
           --name ${NAME} \
           --link letschat:chat \
           -v ${MOUNT_POINT}/data:/var/lib/errbot/data \
           -e 'ERRBOT_LCB_HOSTNAME=chat' \
           -e 'ERRBOT_LCB_TOKEN=NTkyMjAzOTM1ZDAyZWM4MDAwODQ4ZDVhOjZlZDRiNzhjYTYwMzE2NTNlYjQxODczNGI4ODZjZWY0NDgwMjM4MjhhZDBhNTk3Yw==' \
           -e 'ERRBOT_LCB_ROOMS=59214e325d02ec8000848d58' \
           -e 'ERRBOT_LCB_ADMINS=@ktakahashi' \
           -e 'ERRBOT_LCB_NAME=errbot' \
           tkenji/${NAME} \
           $@
