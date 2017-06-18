#!/bin/bash

cd $HOME

if [ "$AVATAR_PROVIDER" == "" ]; then
	AVATAR_PROVIDER="http://www.gravatar.com/avatar"
fi

sed -i "s>YOUR_AVATAR_PROVIDER>$AVATAR_PROVIDER>" /root/lets-chat/settings.yml

exec "$@"
