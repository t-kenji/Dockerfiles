#!/bin/bash

NAME=nginx

docker run -d \
           -ti \
           --name ${NAME} \
           -p 80:80 \
           -p 443:443 \
           --link trac:trac \
           --link kallithea:kallithea \
           --link letschat:letschat \
           --link jenkins-master:jenkins \
           --link janus:janus \
           tkenji/${NAME} \
           $@
