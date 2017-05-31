#!/bin/bash

NAME=janus

docker run -d \
           --name ${NAME} \
           tkenji/${NAME} \
           $@
