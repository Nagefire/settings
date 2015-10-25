#!/bin/sh

server=$(ls ~.i3/tempirc/ | dmenu -b -p "Choose server to read from")
touch ~/.i3/tempirc/$server/\!me.out
recent=$(cat ~/.i3/tempirc/$server/\!me.out | tac)
echo "$recent" | dmenu -b -p 'Msgs from $server:'
