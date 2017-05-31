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
setuptools==33.1.1
Genshi
Jinja2
pysqlite
psycopg2
Babel
docutils
Pygments
pytz
requests
CherryPy
glue
Pillow
sqlalchemy-migrate
git+https://github.com/t-kenji/trac.git@1.2-stable
git+https://github.com/t-kenji/trac-account-manager-plugin.git@aim-for-stable
git+https://github.com/t-kenji/trac-autocomplete-provider-plugin.git
git+https://github.com/t-kenji/trac-avatar-plugin.git
git+https://github.com/t-kenji/trac-blockdiag-macro.git@dev
git+https://github.com/t-kenji/trac-emoji-plugin.git@feature-css-sprite
git+https://github.com/t-kenji/trac-exceldownload-plugin.git
git+https://github.com/t-kenji/trac-fullblog-plugin.git
git+https://github.com/t-kenji/trac-gantt-calendar-plugin.git@hotfix-trac-12-support
git+https://github.com/t-kenji/trac-image-preview-plugin.git
git+https://github.com/t-kenji/trac-keyword-badges-plugin.git
git+https://github.com/t-kenji/trac-letschat-plugin.git
git+https://github.com/t-kenji/trac-mension-plugin.git
git+https://github.com/t-kenji/trac-mikeneko-theme.git
git+https://github.com/t-kenji/trac-perm-redirect-plugin.git
git+https://github.com/t-kenji/trac-privatetickets-plugin.git
git+https://github.com/t-kenji/trac-sectionedit-plugin.git
git+https://github.com/t-kenji/trac-sensitive-tickets-plugin.git
git+https://github.com/t-kenji/trac-tags-plugin.git@hotfix-trac-12-support
git+https://github.com/t-kenji/trac-themeengine-plugin.git
git+https://github.com/t-kenji/trac-ticket-relations-plugin.git
git+https://github.com/t-kenji/trac-ticket-template-plugin.git
git+https://github.com/t-kenji/trac-xml-rpc-plugin.git
__EOS__
	./venv/bin/pip install -r ${requirements}
else
	echo "[INFO] venv already exists."
fi

if [ ! -d /var/lib/trac/deploy ]; then
	./venv/bin/trac-admin /var/lib/trac/sites/trac-plugin-test deploy /var/lib/trac/deploy
fi

exec "$@"
