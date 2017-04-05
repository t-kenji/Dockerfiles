#!/bin/bash

docker run -ti \
           --cap-add=SYS_ADMIN \
           --security-opt=apparmor:unconfined \
           --device=/dev/loop-control:/dev/loop-control \
           --device=/dev/loop0:/dev/loop0 \
           --device=/dev/loop1:/dev/loop1 \
           --device=/dev/loop2:/dev/loop2 \
           --device=/dev/loop3:/dev/loop3 \
           --device=/dev/loop4:/dev/loop4 \
           --device=/dev/loop5:/dev/loop5 \
           --device=/dev/loop6:/dev/loop6 \
           --device=/dev/loop7:/dev/loop7 \
           --name loopdevice \
           tkenji/loopdevice
