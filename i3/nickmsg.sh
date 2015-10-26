#!/bin/sh

server=$(ls ~/irc/ | grep -v "in$" | dmenu -b -p "Server channel is on:")
channel=$(ls ~/irc/$server/ | grep -v "in$" | grep -v "out$" | grep -v "^$" | dmenu -b -p "Channel user is on: ")
echo "/names" >> ~/irc/$server/in
nicks=$(tac ~/irc/$server/out | grep -m 1 "= $channel")
echo "$nicks"
nicks=$(echo "$nicks" | sed -re "s/^[0-9]+-[0-9]+-[0-9]+ [0-9]+:[0-9]+ = $channel //g" | sed "s/ /\n/g")
echo -e "$nicks" | dmenu -b -p "Tab complete a nick and type message:" >> ~/irc/$server/$channel/in
