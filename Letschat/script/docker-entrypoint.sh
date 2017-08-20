#!/bin/bash

cd $HOME

if [ "$LETSCHAT_XMPP_DOMAIN" == "" ]; then
	LETSCHAT_XMPP_DOMAIN=example.com
fi
if [ "$LETSCHAT_AVATAR_PROVIDER" == "" ]; then
	LETSCHAT_AVATAR_PROVIDER=http://www.gravatar.com/avatar
fi

sed -i -e "s>YOUR_XMPP_DOMAIN>$LETSCHAT_XMPP_DOMAIN>" \
       -e "s>YOUR_AVATAR_PROVIDER>$LETSCHAT_AVATAR_PROVIDER>" \
       /root/lets-chat/settings.yml

exec "$@"
