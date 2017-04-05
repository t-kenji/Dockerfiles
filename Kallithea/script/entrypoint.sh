#!/bin/bash

cd $HOME

if [ ! -d kallithea-mirror ]; then
	git clone https://github.com/t-kenji/kallithea-mirror.git
else
	echo "[INFO] kallithea-mirror already exists."
fi

if [ ! -d kallithea-rcextensions ]; then
	git clone https://github.com/t-kenji/kallithea-rcexensions.git
else
	echo "[INFO] kallithea-rcextensions already exists."
fi

if [ ! -d kallithea-venv ]; then
	virtualenv --no-site-packages kallithea-venv
	cat << __EOS__ >> ./kallitea-venv/lib/python2.7/sitecustomize.py
try:
	import sys
except ImportError:
	pass
else:
	sys.setdefaultencoding('utf-8')
__EOS__
	cd kallithea-mirror
	../kallithea-venv/bin/python setup.py compile_catalog
	../kallithea-venv/bin/pip install .
	cd -
else
	echo "[INFO] kallithea-venv already exists."
fi

if [ ! -d kallithea-data ]; then
	mkdir kallithea-data
	./kallithea-venv/bin/paster make-config kallithea kallithea-data/production.ini
	sed -i "s/host = 127.0.0.1/host = 0.0.0.0/" kallithea-data/production.ini
	sed -i "s/port = 5000/port = 5010/" kallithea-data/production.ini
	sed -i "s/lang =\( en\)*/lang = ja/" kallithea-data/production.ini
	sed -i "s/default_encoding = utf8/default_encoding = utf8, cp932/" kallithea-data/production.ini
	sed -i "s/sqlalchemy.db1.url = sqlite:/#sqlalchemy.db1.url = sqlite:/" kallithea-data/production.ini
	sed -i "s/#sqlalchemy.db1.url = postgresql:\/\/user:pass@localhost/sqlalchemy.db1.url = postgresql:\/\/kallithea@db/" kallithea-data/production.ini
fi

exec $@
