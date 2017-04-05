#!/bin/bash

docker run -ti \
           --name errbot\
           tkenji/errbot \
           $@
