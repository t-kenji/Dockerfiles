#!/opt/venv/trac/bin/python
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
activate_this = '/opt/venv/trac/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))

import os
import argparse
import cherrypy

project_name = ""
project_port = 8000

def application(environ, start_request):
    if not 'trac.env_parent_dir' in environ:
        environ.setdefault('trac.env_path', '/var/lib/trac/sites/{}'.format(project_name))
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

if __name__ == '__main__':

    # Parse cmdline arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('project_name')
    parser.add_argument('project_port')
    args = parser.parse_args()

    # Mount the application
    project_name = args.project_name
    cherrypy.tree.graft(application, '/{}'.format(project_name))

    # Unsubscribe the default server
    cherrypy.server.unsubscribe()

    # Instantiate a new server object
    server = cherrypy._cpserver.Server()

    # Configure the server object
    #server.socket_host = "127.0.0.1"
    server.socket_host = "0.0.0.0"
    server.socket_port = int(args.project_port)
    server.thread_pool = 3

    # Subscribe this server
    server.subscribe()

    # Start the server engine (Option 1 *and* 2)
    cherrypy.engine.start()
    cherrypy.engine.block()
