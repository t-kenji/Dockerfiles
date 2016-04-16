#!/bin/bash

docker run -d \
	       -p 8080:8080 \
		   --name jenkins-master \
		   --link jenkins-slave-program-1:slave-program-1 \
		   --link jenkins-slave-document-1:slave-document-1 \
	       tkenji/jenkins-master
