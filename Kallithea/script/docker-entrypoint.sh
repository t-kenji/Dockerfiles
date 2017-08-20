#!/bin/bash

cd $HOME

until psql -h postgres  -U "kallithea" -c '\l'; do
	echo "[INFO] Postgres is unavailable - waiting"
	sleep 1
done

if [ ! -e $RCDATA/production.ini ]; then
	./venv/bin/paster make-config kallithea $RCDATA/production.ini
	sed -i -e "s/host = 127.0.0.1/host = 0.0.0.0/" \
	       -e "s/port = 5000/port = 5010/" \
	       -e "s/^#\(\[filter:proxy-prefix\]\)$/\1/" \
	       -e "s/^#\(use = egg:PasteDeploy#prefix\)$/\1/" \
	       -e "s/^#prefix = \/<your-prefix>$/prefix = \/kallithea/" \
	       -e "s/lang =\( en\)*/lang = ja/" \
	       -e "s/use_htsts = false/use_htsts = true/" \
	       -e "s/default_encoding = utf8/default_encoding = utf8, cp932/" \
	       -e "s/sqlalchemy.db1.url = sqlite:/#sqlalchemy.db1.url = sqlite:/" \
	       -e "s/#sqlalchemy.db1.url = postgresql:\/\/user:pass@localhost/sqlalchemy.db1.url = postgresql:\/\/kallithea@postgres/" \
	       $RCDATA/production.ini

	yes | ./venv/bin/paster setup-db $RCDATA/production.ini --user=$KALLITHEA_ADMIN_USER --password=$KALLITHEA_ADMIN_PASS --email=$KALLITHEA_ADMIN_EMAIL --repos=$RCREPO
	sed -i -e "s/^#\(filter-with = proxy-prefix\)/\1/" $RCDATA/production.ini
else:
	echo "[INFO] already production.ini exists."
fi

exec "$@"
