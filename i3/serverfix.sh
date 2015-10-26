#!/bin/sh

server=$(ls ~/irc/ | grep -v "^in$" | dmenu -b -p "Server:")
cat ~/irc/$server/out > ~/.i3/tempirc/${server}.out
