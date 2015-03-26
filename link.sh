#! /bin/sh

export REPO=`pwd`

ln -fs $REPO/vimrc ~/.vimrc
ln -fs $REPO/gitconfig ~/.gitconfig
ln -fs $REPO/xbindkeysrc ~/.xbindkeysrc
ln -fs $REPO/xmodmap ~/.xmodmap
ln -fs $REPO/Xresources ~/.Xresources
ln -fs $REPO/xsession ~/.xsession
cp -rf $REPO/config/* ~/.config

rm -rf ~/.vim/plugin_settings
ln -fs $REPO/vim/plugin_settings ~/.vim/plugin_settings

rm -rf ~/.vim/after
ln -fs $REPO/vim/after ~/.vim/after


if [ "`id -u`" = "0" ]; then
  ln -fs $REPO/i3status.conf /etc/i3status.conf
fi
