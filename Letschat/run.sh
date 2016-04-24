#!/bin/bash

docker run -d \
	       -p 5000:5000 \
	       --name letschat \
		   --link mongodb:db \
		   tkenji/letschat
