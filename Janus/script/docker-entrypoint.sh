#!/bin/bash

sed -i 's/cert_pem = .\+/cert_pem = \/usr\/share\/certs\/cert.crt/' /usr/etc/janus/janus.cfg
sed -i 's/cert_key = .\+/cert_key = \/usr\/share\/certs\/cert.key/' /usr/etc/janus/janus.cfg
sed -i 's/^;interface = /interface = /' /usr/etc/janus/janus.transport.http.cfg
sed -i 's/^https = no/https = yes/' /usr/etc/janus/janus.transport.http.cfg
sed -i 's/^;secure_port = /secure_port = /' /usr/etc/janus/janus.transport.http.cfg
sed -i 's/^;secure_interface = /secure_interface = /' /usr/etc/janus/janus.transport.http.cfg
sed -i 's/cert_pem = .\+/cert_pem = \/usr\/share\/certs\/cert.crt/' /usr/etc/janus/janus.transport.http.cfg
sed -i 's/cert_key = .\+/cert_key = \/usr\/share\/certs\/cert.key/' /usr/etc/janus/janus.transport.http.cfg
sed -i 's/^wws = no/wws = yes/' /usr/etc/janus/janus.transport.websockets.cfg
sed -i 's/^;wss_port = /wss_port = /' /usr/etc/janus/janus.transport.websockets.cfg
sed -i 's/cert_pem = .\+/cert_pem = \/usr\/share\/certs\/cert.crt/' /usr/etc/janus/janus.transport.websockets.cfg
sed -i 's/cert_key = .\+/cert_key = \/usr\/share\/certs\/cert.key/' /usr/etc/janus/janus.transport.websockets.cfg

exec "$@"
