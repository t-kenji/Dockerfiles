#!/bin/bash

cd $HOME

if [ ! -d lets-chat ]; then
	git clone -b custom https://github.com/t-kenji/lets-chat.git
	cd lets-chat
	cp settings.yml.sample settings.yml
	patch -u settings.yml < $HOME/settings.yml.patch
	npm install
fi

exec $@
