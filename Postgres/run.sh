#!/bin/bash

docker run -ti \
           --name postgres \
		   tkenji/postgres \
           $@
