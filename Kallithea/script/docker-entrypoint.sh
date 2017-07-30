#!/bin/bash

cd $HOME

until psql -h db -U "kallithea" -c '\l'; do
	echo "[INFO] Postgres is unavailable - waiting"
	sleep 1
done

if [ ! -e $RCDATA/production.ini ]; then
	./venv/bin/paster make-config kallithea $RCDATA/production.ini
	ln -s ../kallithea-rcextensions/rcextentions $RCDATA/
	sed -i "s/host = 127.0.0.1/host = 0.0.0.0/" $RCDATA/production.ini
	sed -i "s/port = 5000/port = 5010/" $RCDATA/production.ini
	sed -i "s/^#\(\[filter:proxy-prefix\]\)$/\1/" $RCDATA/production.ini
	sed -i "s/^#\(use = egg:PasteDeploy#prefix\)$/\1/" $RCDATA/production.ini
	sed -i "s/^#prefix = \/<your-prefix>$/prefix = \/kallithea/" $RCDATA/production.ini
	sed -i "s/lang =\( en\)*/lang = ja/" $RCDATA/production.ini
	sed -i "s/use_htsts = false/use_htsts = true/" $RCDATA/production.ini
	sed -i "s/default_encoding = utf8/default_encoding = utf8, cp932/" $RCDATA/production.ini
	sed -i "s/sqlalchemy.db1.url = sqlite:/#sqlalchemy.db1.url = sqlite:/" $RCDATA/production.ini
	sed -i "s/#sqlalchemy.db1.url = postgresql:\/\/user:pass@localhost/sqlalchemy.db1.url = postgresql:\/\/kallithea@db/" $RCDATA/production.ini

	yes | ./venv/bin/paster setup-db $RCDATA/production.ini --user=$KALLITHEA_ADMIN_USER --password=$KALLITHEA_ADMIN_PASS --email=$KALLITHEA_ADMIN_EMAIL --repos=$RCREPO
	sed -i "s/^#\(filter-with = proxy-prefix\)/\1/" $RCDATA/production.ini
else:
	echo "[INFO] already production.ini exists."
fi

exec "$@"
