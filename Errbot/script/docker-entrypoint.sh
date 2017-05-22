#!/bin/bash

cd $HOME

if [ ! -d errbot-moogle ]; then
	git clone https://github.com/t-kenji/errbot-moogle.git
	sed -i "s/ROOTDIR = .\+/ROOTDIR = r'\/root\/errbot-moogle'/" errbot-moogle/config.py
	sed -i "s/BOT_DATA_DIR = .\+/BOT_DATA_DIR = r'\/var\/lib\/errbot\/data'/" errbot-moogle/config.py
else
	echo "[INFO] errbot-moogle already exists."
fi

if [ ! -d venv ]; then
	python -m venv venv
	./venv/bin/pip install errbot socketio-client pytz crontab
else
	echo "[INFO] venv already exists."
fi

exec $@
