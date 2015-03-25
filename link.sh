#! /bin/sh

export REPO=/home/pin3da/repos/dotfiles

ln -fs $REPO/vimrc ~/.vimrc
ln -fs $REPO/gitconfig ~/.gitconfig
ln -fs $REPO/xbindkeysrc ~/.xbindkeysrc
ln -fs $REPO/xmodmap ~/.xmodmap
ln -fs $REPO/Xresources ~/.Xresources
ln -fs $REPO/xsession ~/.xessions
ln -fs $REPO/config/ ~/.config
ln -fs $REPO/i3status.conf /etc/i3status.conf
