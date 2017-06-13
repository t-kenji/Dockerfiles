#!/bin/bash

sed -i 's/\(worker_processes\)  1;/\1  auto;/' /etc/nginx/nginx.conf

exec "$@"
