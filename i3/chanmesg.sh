#!/bin/sh

server=$(ls ~/irc/ | grep -v "in$" | dmenu -b -p "Server of channel:")
channel=$(ls ~/irc/$server/ | grep -v "in$" | grep -v "out$" | dmenu -b -p "Channel:")
msg=$(xsel -o | dmenu -b -p "Msg to $channel:")
echo "$msg" >> ~/irc/$server/$channel/in
