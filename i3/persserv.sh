#!/bin/sh

server=$(ls ~/.i3/tempirc/ | egrep ".\.out" | grep -v "^in" | sed "s/\.out//g" | dmenu -b -p "Choose server to read from")
touch ~/.i3/tempirc/${server}.out
recent=$(cat ~/.i3/tempirc/${server}.out | tac)
echo "$recent" | grep -v "^$" | dmenu -b -p 'Msgs from $server:' | xsel -i
