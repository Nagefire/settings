#!/bin/bash
if [ -f $HOME/.config/dmenurc ]; then
	source $HOME/.config/dmenurc
else
	DMENU="dmenu -b -fn 'Terminus-10' -sb red -sf green -nf #000000 -nb #ffffff"
fi

function open {
	i3-msg -t command workspace $(i3-msg -t get_workspaces | sed "s/,/\n/g" | grep "^\"name\":" | sed "s/^\"name\":\"//" | sed "s/\"$//" | grep -v "[0-9]" | $DMENU -p "Workspaces:")
}

function send {
	i3-msg -t command move workspace $(i3-msg -t get_workspaces | sed 's/,/\n/g' | grep '\"name\":' | sed 's/\"name\":\"//g' | sed 's/\"$//g' | grep -v "[0-9]" | $DMENU -p 'Workspaces:')
}

$1
