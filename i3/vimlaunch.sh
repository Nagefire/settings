#!/bin/sh

if [ -f $HOME/.config/dmenurc ]; then
	source $HOME/.config/dmenurc
else
	DMENU="dmenu -b -fn 'Terminus-10' -nf #000000 -nb #ffffff -sf green -sb red"
fi

com=`echo "" | $DMENU -p "To open in vim:"`
urxvtc -e sh -c 'vim $com'
