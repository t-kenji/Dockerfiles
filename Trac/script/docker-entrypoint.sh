#!/bin/bash

cd $HOME

if [ ! -d ./venv ]; then
	virtualenv --no-site-packages venv
	cat << __EOS__ >> ./venv/lib/python2.7/sitecustomize.py
try:
	import sys
except ImportError:
	pass
else:
	sys.setdefaultencoding('utf-8')
__EOS__
	requirements=`mktemp`
	cat << __EOS__ >> ${requirements}
Genshi
Jinja2
pysqlite
psycopg2
Babel
docutils
Pygments
pytz
requests
openpyxl
CherryPy
glue
Pillow
blockdiag
seqdiag
actdiag
nwdiag
blockdiagcontrib-cisco
sqlalchemy-migrate
git+https://github.com/t-kenji/trac.git@1.2-stable
git+https://github.com/t-kenji/trac-account-manager-plugin.git@0.5-dev
git+https://github.com/t-kenji/trac-autocomplete-provider-plugin.git
git+https://github.com/t-kenji/trac-avatar-plugin.git
git+https://github.com/t-kenji/trac-blockdiag-macro.git@dev
git+https://github.com/t-kenji/trac-emoji-plugin.git@feature-css-sprite
git+https://github.com/t-kenji/trac-excel-download-plugin.git
git+https://github.com/t-kenji/trac-fullblog-plugin.git
git+https://github.com/t-kenji/trac-gantt-calendar-plugin.git@hotfix-trac-12-support
git+https://github.com/t-kenji/trac-image-preview-plugin.git
git+https://github.com/t-kenji/trac-include-macro.git
git+https://github.com/t-kenji/trac-keyword-labels-plugin.git
git+https://github.com/t-kenji/trac-letschat-plugin.git
git+https://github.com/t-kenji/trac-mension-plugin.git
git+https://github.com/t-kenji/trac-mermaid-macro.git
git+https://github.com/t-kenji/trac-mikeneko-theme.git
git+https://github.com/t-kenji/trac-multi-select-field-plugin.git
git+https://github.com/t-kenji/trac-perm-redirect-plugin.git
git+https://github.com/t-kenji/trac-privatetickets-plugin.git
git+https://github.com/t-kenji/trac-sectionedit-plugin.git
git+https://github.com/t-kenji/trac-tags-plugin.git
git+https://github.com/t-kenji/trac-theme-engine-plugin.git
git+https://github.com/t-kenji/trac-ticket-relations-plugin.git
git+https://github.com/t-kenji/trac-ticket-template-plugin.git
git+https://github.com/t-kenji/trac-xml-rpc-plugin.git
__EOS__
	./venv/bin/pip install setuptools==33.1.1
	./venv/bin/pip install -r ${requirements}
else
	echo "[INFO] venv already exists."
fi

source ./venv/bin/activate

if [ "$TRAC_PROJECT_NAME" == "" ]; then
	TRAC_PROJECT_NAME=trac-project-sample
fi

SITES_DIR=/var/lib/trac/sites
if [ ! -d $SITES_DIR ]; then
	mkdir -p $SITES_DIR
	trac-admin $SITES_DIR/$TRAC_PROJECT_NAME initenv $TRAC_PROJECT_NAME sqlite:db/trac.db
	cp -f $HOME/trac.ini.template $SITES_DIR/$TRAC_PROJECT_NAME/conf/trac.ini
	sed -i "s/YOUR_TRAC_PROJECT/$TRAC_PROJECT_NAME/g" $SITES_DIR/$TRAC_PROJECT_NAME/conf/trac.ini
	sed -i "s/YOUR_REVERSE_PROXY/$REVERSE_PROXY/g" $SITES_DIR/$TRAC_PROJECT_NAME/conf/trac.ini
	trac-admin $SITES_DIR/$TRAC_PROJECT_NAME upgrade
	trac-admin $SITES_DIR/$TRAC_PROJECT_NAME wiki upgrade
	echo "$TRAC_PROJECT_NAME:8001" >> $SITES_DIR/servers.txt
fi

DEPLOY_DIR=/var/lib/trac/deploy
if [ ! -d $DEPLOY_DIR ]; then
	trac-admin $SITES_DIR/trac-project-sample deploy $DEPLOY_DIR/trac-project-sample
fi

for l in `cat $SITES_DIR/servers.txt`; do
	cols=(`echo $l | tr -s ':' ' '`)
	project=${cols[0]}
	port=${cols[1]}
	cat << __EOS__ > /etc/supervisor.d/${project}.ini
[program:${project}]
directory = /root
command = /root/venv/bin/python /root/bootstrap.py ${project} ${port}
autorestart = true
redirect_stderr = true
stdout_logfile = /var/log/${project}.log
__EOS__
done

exec "$@"
