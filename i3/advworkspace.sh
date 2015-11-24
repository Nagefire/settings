#!/bin/sh
function open {
	i3-msg -t command workspace $(i3-msg -t get_workspaces | sed "s/,/\n/g" | grep "^\"name\":" | sed "s/^\"name\":\"//" | sed "s/\"$//" | grep -v "[0-9]" | dmenu -b -p "Workspaces:")
}

function send {
	i3-msg -t command move workspace $(i3-msg -t get_workspaces | sed 's/,/\n/g' | grep '\"name\":' | sed 's/\"name\":\"//g' | sed 's/\"$//g' | grep -v "[0-9]" | dmenu -b -p 'Workspaces:')
}

$1
