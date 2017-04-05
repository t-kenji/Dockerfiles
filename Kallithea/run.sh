#!/bin/bash

docker run -ti \
           -d \
           --name kallithea \
           --link postgres:db \
           -p 5010:5010 \
           -v `pwd`/home:/root \
           tkenji/kallithea \
           $@
