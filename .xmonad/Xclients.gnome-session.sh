#!/bin/bash
# Pretend to be Gnome to persuade gdm to launch us
# Drop this in /etc/X11/xinit/Xclients.d/

XCOMPMGR=$HOME/bin/xcompmgr
XMONAD=$HOME/.cabal/bin/xmonad

[ -x $XCOMPMGR ] && $XCOMPMGR -n &
if [ -x $XMONAD ]; then
	$XMONAD &
fi
/usr/bin/gnome-session
