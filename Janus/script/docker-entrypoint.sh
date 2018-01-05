#!/bin/bash

sed -e 's/cert_pem = .\+/cert_pem = \/usr\/share\/certs\/cert.crt/' \
    -e 's/cert_key = .\+/cert_key = \/usr\/share\/certs\/cert.key/' \
    -i /usr/etc/janus/janus.cfg
sed -e 's/^;interface = /interface = /' \
    -e 's/^https = no/https = yes/' \
    -e 's/^;secure_port = /secure_port = /' \
    -e 's/^;secure_interface = /secure_interface = /' \
    -e 's/cert_pem = .\+/cert_pem = \/usr\/share\/certs\/cert.crt/' \
    -e 's/cert_key = .\+/cert_key = \/usr\/share\/certs\/cert.key/' \
    -i /usr/etc/janus/janus.transport.http.cfg
sed -e 's/^wws = no/wws = yes/' \
    -e 's/^;wss_port = /wss_port = /' \
    -e 's/cert_pem = .\+/cert_pem = \/usr\/share\/certs\/cert.crt/' \
    -e 's/cert_key = .\+/cert_key = \/usr\/share\/certs\/cert.key/' \
    -i /usr/etc/janus/janus.transport.websockets.cfg

exec "$@"
