#!/bin/bash

cd $HOME

source ./venv/bin/activate

if [ "$TRAC_PROJECT_NAME" == "" ]; then
	TRAC_PROJECT_NAME=trac-project-sample
fi
if [ "$TRAC_LCB_HOSTNAME" == "" ]; then
	TRAC_LCB_HOSTNAME=letschat
fi
if [ "$TRAC_LCB_PORT" == "" ]; then
	TRAC_LCB_PORT=5000
fi

SITES_DIR=/var/lib/trac/sites
if [ ! -d $SITES_DIR ]; then
	mkdir -p $SITES_DIR
	trac-admin $SITES_DIR/$TRAC_PROJECT_NAME initenv $TRAC_PROJECT_NAME sqlite:db/trac.db
	sed -i -e "s/YOUR_LETSCHAT_HOST/$TRAC_LCB_HOSTNAME/g" \
	       -e "s/YOUR_LETSCHAT_PORT/$TRAC_LCB_PORT/g" \
	       -e "s/YOUR_LETSCHAT_TOKEN/$TRAC_LCB_TOKEN/g" \
	       -e "s/YOUR_LETSCHAT_BLOG_ROOM/$TRAC_LCB_BLOG_ROOM/g" \
	       -e "s/YOUR_LETSCHAT_TICKET_ROOM/$TRAC_LCB_TICKET_ROOM/g" \
	       -e "s/YOUR_LETSCHAT_WIKI_ROOM/$TRAC_LCB_WIKI_ROOM/g" \
	       -e "s/YOUR_TRAC_PROJECT/$TRAC_PROJECT_NAME/g" \
	       -e "s/YOUR_REVERSE_PROXY/$REVERSE_PROXY/g" \
	       $HOME/trac.ini.template
	cp -f $HOME/trac.ini.template $SITES_DIR/$TRAC_PROJECT_NAME/conf/trac.ini
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
