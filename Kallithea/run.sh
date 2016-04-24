#!/bin/bash

docker run -d \
	       -p 5010:5010 \
		   --name kallithea \
	       tkenji/kallithea
