#!/bin/bash

if [ -f $HOME/.config/dmenu ]; then
	source $HOME/config/dmenu
else
	DMENU="dmenu -b -l 4 -fn 'Terminus-10' -sf green -sb red -nb #ffffff -nf #000000"
fi

if [[ "$1" == "" ]]; then
	cd "$(cat $HOME/.local/share/dmenufm)"
else
	cd $1
fi

response="Null"

while [[ "$response" != "" ]]; do
	response=$(ls -a | $DMENU -p "$(pwd):" -l 20)
	if [[ "$response" == "" ]]; then
		break
	elif [ -d "$response" ]; then
		cd "$response"
	else
		ext=$(xdg-mime query filetype $response)
		results=$(grep "$ext" $HOME/.local/share/dmenufm.allowed)
		if [[ "$results" != "" ]]; then
			xdg-open $response
			break
		fi
	fi
done

echo "$(pwd)" > $HOME/.local/share/dmenufm
