#!/bin/bash

cd $HOME

if [ ! -d $MONGODATA/db ]; then
	mkdir -p $MONGODATA/db
fi

exec "$@"
