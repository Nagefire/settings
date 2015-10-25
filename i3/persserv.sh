#!/bin/sh

server=$(ls ~/.i3/tempirc/ | egrep ".\.out" | dmenu -b -p "Choose server to read from")
touch ~/.i3/tempirc/$server
recent=$(cat ~/.i3/tempirc/$server | tac)
echo "$recent" | dmenu -b -p 'Msgs from $server:'
