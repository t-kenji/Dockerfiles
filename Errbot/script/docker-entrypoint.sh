#!/bin/bash

cd $HOME

sed -i -e "s/ROOTDIR = .\+/ROOTDIR = r'\/root\/errbot-moogle'/" \
       -e "s/BOT_DATA_DIR = .\+/BOT_DATA_DIR = r'\/var\/lib\/errbot\/data'/" \
       -e "s/BOT_EXTRA_PLUGIN_DIR = .\+/BOT_EXTRA_PLUGIN_DIR = r'\/var\/lib\/errbot\/plugins'/" \
       errbot-moogle/config.py

exec "$@"
