#!/root/venv/bin/python
# -*- coding: utf-8 -*-
#
# Copyright (C)2008-2009 Edgewall Software
# Copyright (C) 2008 Noah Kantrowitz <noah@coderanger.net>
# All rights reserved.
#
# This software is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at http://trac.edgewall.org/wiki/TracLicense.
#
# This software consists of voluntary contributions made by many
# individuals. For the exact contribution history, see the revision
# history and logs, available at http://trac.edgewall.org/log/.
#
# Author: Noah Kantrowitz <noah@coderanger.net>

# Activate virtual environment
activate_this = '/root/venv/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))

import os
import argparse
import cherrypy

def application(environ, start_request):
    if not 'trac.env_parent_dir' in environ:
        environ.setdefault('trac.env_path', '/var/lib/trac/sites/{}'.format(os.environ.get('TRAC_PROJECT_NAME', '')))
    if 'PYTHON_EGG_CACHE' in environ:
        os.environ['PYTHON_EGG_CACHE'] = environ['PYTHON_EGG_CACHE']
    elif 'trac.env_path' in environ:
        os.environ['PYTHON_EGG_CACHE'] = \
            os.path.join(environ['trac.env_path'], '.egg-cache')
    elif 'trac.env_parent_dir' in environ:
        os.environ['PYTHON_EGG_CACHE'] = \
            os.path.join(environ['trac.env_parent_dir'], '.egg-cache')
    from trac.web.main import dispatch_request
    return dispatch_request(environ, start_request)

def main():
    # Parse cmdline arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('project_name')
    parser.add_argument('project_port')
    args = parser.parse_args()
    os.environ['TRAC_PROJECT_NAME'] = args.project_name
    os.environ['TRAC_PROJECT_PORT'] = args.project_port

    # Mount the application
    cherrypy.tree.graft(application, '/{}'.format(os.environ.get('TRAC_PROJECT_NAME', '')))

    # Unsubscribe the default server
    cherrypy.server.unsubscribe()

    # Instantiate a new server object
    server = cherrypy._cpserver.Server()

    # Configure the server object
    #server.socket_host = "127.0.0.1"
    server.socket_host = "0.0.0.0"
    server.socket_port = int(os.environ.get('TRAC_PROJECT_PORT', '8000'))
    server.thread_pool = 3

    # Subscribe this server
    server.subscribe()

    # Start the server engine (Option 1 *and* 2)
    cherrypy.engine.start()
    cherrypy.engine.block()

if __name__ == '__main__':
    main()
