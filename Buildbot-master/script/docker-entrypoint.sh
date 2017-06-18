#!/bin/bash

cd $HOME

. ./venv/bin/activate

if [ ! -d $BBDATA/master ]; then
	buildbot create-master -r $BBDATA/master
	cp $BBDATA/master/master.cfg.sample $BBDATA/master/master.cfg
fi

exec "$@"
