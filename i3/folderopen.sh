#!/bin/bash

if [ -f $HOME/.config/dmenu ]; then
	source $HOME/config/dmenu
else
	DMENU="dmenu -b -l 4 -fn 'Terminus-10' -sf green -sb red -nb #ffffff -nf #000000"
fi

cd "$(cat $HOME/.local/share/dmenufm)"

op=""

if [[ "$1" == ""  ]]; then
	op=mpv
else
	op="$1"
fi

response="Null"

while [[ "$response" != "" ]]; do
	response=$(ls -a | $DMENU -p "$(pwd):" -l 20)
	if [[ "$response" == "" ]]; then
		break
	elif [ -d "$response" ]; then
		$op "$response"/*
	else
		ext=$(xdg-mime query filetype $response)
		results=$(grep "$ext" $HOME/.local/share/dmenufm.allowed)
		if [[ "$results" != "" ]]; then
			xdg-open "$response"
			break
		fi
	fi
done

echo "$(pwd)" > $HOME/.local/share/dmenufm
