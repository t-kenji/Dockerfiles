#!/bin/bash

cd $HOME

if [ ! -d kallithea-mirror ]; then
	git clone https://github.com/t-kenji/kallithea-mirror.git
else
	echo "[INFO] kallithea-mirror already exists."
fi

if [ ! -d kallithea-rcextensions ]; then
	git clone https://github.com/t-kenji/kallithea-rcextensions.git
else
	echo "[INFO] kallithea-rcextensions already exists."
fi

if [ ! -d venv ]; then
	virtualenv --no-site-packages venv
	cat << __EOS__ >> ./venv/lib/python2.7/sitecustomize.py
try:
	import sys
except ImportError:
	pass
else:
	sys.setdefaultencoding('utf-8')
__EOS__
	cd kallithea-mirror
	../venv/bin/pip install setuptools==33.1.1 Babel==1.3 psycopg2 sqlalchemy-migrate
	../venv/bin/python setup.py compile_catalog
	../venv/bin/pip install .
	cd -
else
	echo "[INFO] venv already exists."
fi

if [ ! -e $RCDATA/production.ini ]; then
	mkdir -p $RCDATA
	./venv/bin/paster make-config kallithea $RCDATA/production.ini
	ln -s ../kallithea-rcextensions/rcextentions $RCDATA/
	sed -i "s/host = 127.0.0.1/host = 0.0.0.0/" $RCDATA/production.ini
	sed -i "s/port = 5000/port = 5010/" $RCDATA/production.ini
	sed -i "s/lang =\( en\)*/lang = ja/" $RCDATA/production.ini
	sed -i "s/default_encoding = utf8/default_encoding = utf8, cp932/" $RCDATA/production.ini
	sed -i "s/sqlalchemy.db1.url = sqlite:/#sqlalchemy.db1.url = sqlite:/" $RCDATA/production.ini
	sed -i "s/#sqlalchemy.db1.url = postgresql:\/\/user:pass@localhost/sqlalchemy.db1.url = postgresql:\/\/kallithea@db/" $RCDATA/production.ini
fi

exec "$@"
