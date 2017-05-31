#!/bin/bash

sed -i 's/^https = no/https = yes/' /usr/local/etc/janus/janus.transport.http.cfg
sed -i 's/^;secure_port = /secure_port = /' /usr/local/etc/janus/janus.transport.http.cfg
sed -i 's/^wws = no/wws = yes/' /usr/local/etc/janus/janus.transport.websockets.cfg
sed -i 's/^;wss_port = /wss_port = /' /usr/local/etc/janus/janus.transport.websockets.cfg

exec "$@"
