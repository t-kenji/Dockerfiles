#!/bin/bash

# Create user.
useradd -d $HOME -m -s /bin/bash $USER
echo "$USER:$USER" | chpasswd
echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Setup gtags.vim
if [ -f ~/.vim/plugin/gtags.vim ]; then
	mkdir -p ~/.vim/plugin
	cp /usr/share/gtags/gtags.vim ~/.vim/plugin/
fi

chown $USER:$USER -R ~

exec "$@"
