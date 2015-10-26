#!/bin/sh

server=$(ls ~/irc/ | grep -v "^in$" | dmenu -b -p "Server channel is on:")
channel=$(ls ~/irc/$server/ | egrep -v "^out$|^in$" | dmenu -b -p "Channel:")
cat ~/irc/$server/$channel/out > ~/.i3/tempirc/$server/$channel
