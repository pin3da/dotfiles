#! /bin/sh

export REPO=`pwd`

ln -fs $REPO/vimrc ~/.vimrc
ln -fs $REPO/gitconfig ~/.gitconfig
ln -fs $REPO/xbindkeysrc ~/.xbindkeysrc
ln -fs $REPO/xmodmap ~/.xmodmap
ln -fs $REPO/Xresources ~/.Xresources
ln -fs $REPO/xsession ~/.xessions
cp -rf $REPO/config/* ~/.config

if [ "`id -u`" = "0" ]; then
  ln -fs $REPO/i3status.conf /etc/i3status.conf
fi
