#!/bin/sh

server=$(ls ~/.i3/tempirc/ | dmenu -b -p "Server channel is on:")
channel=$(ls ~/.i3/tempirc/$server/ | grep -v "\!me.out" | dmenu -b -p "What channel to read?")
recent=$(cat ~/.i3/tempirc/$server/$channel | tac)
echo "$recent" | dmenu -b -p "Msgs from $server/$channel"
