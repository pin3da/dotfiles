#! /bin/sh

export REPO=`pwd`

ln -fs $REPO/vimrc ~/.vimrc
ln -fs $REPO/gitconfig ~/.gitconfig
ln -fs $REPO/xmodmap ~/.xmodmap
ln -fs $REPO/Xresources ~/.Xresources
ln -fs $REPO/xsession ~/.xsession
ln -fs $REPO/i3config ~/.i3/config
cp -rf $REPO/config/* ~/.config

rm -rf ~/.vim/plugin_settings
ln -fs $REPO/vim/plugin_settings ~/.vim/plugin_settings

rm -rf ~/.vim/after
ln -fs $REPO/vim/after ~/.vim/after
