#!/bin/bash

cd $HOME

if [ "$REVERSE_PROXY" != "" ]; then
	sed -i "s/YOUR_SERVER/$REVERSE_PROXY/" /root/lets-chat/settings.yml
fi

exec "$@"
