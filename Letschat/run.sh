#!/bin/bash

NAME=letschat

docker run -d \
           -p 5000:5000 \
           --name ${NAME} \
           --link mongodb:db \
           tkenji/${NAME} \
           $@
