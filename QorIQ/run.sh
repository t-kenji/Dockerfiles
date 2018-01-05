#!/bin/bash

NAME=qoriq

docker run -ti -d \
           --rm \
           --cap-add SYS_ADMIN \
           --cap-add NET_ADMIN \
           --security-opt apparmor=unconfined \
           --security-opt seccomp=unconfined \
           --device /dev/loop-control \
           --device /dev/loop0 \
           --device /dev/loop1 \
           --device /dev/loop2 \
           --device /dev/loop3 \
           --device /dev/loop4 \
           --device /dev/loop5 \
           --device /dev/loop6 \
           --device /dev/loop7 \
           --device /dev/net/tun \
           --volume ~/.docker-containers/volumes/qoriq:/home/tkenji \
           --name $NAME \
           tkenji/$NAME

docker exec -ti -u tkenji $NAME script -q -c "/bin/bash" /dev/null
