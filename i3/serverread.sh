#!/bin/sh
server=$(ls ~/irc/ | grep -v "in$" | dmenu -b -p "Choose server to read from")

touch ~/.i3/tempirc/${server}.out

togrep=$(cat ~/.i3/tempirc/${server}.out)
if [ "$togrep" != "" ]; then
	out=$(grep -F -v "$togrep" ~/irc/$server/out)
else
	out=$(cat ~/irc/$server/out)
fi

out=$(echo -e "$out" | grep -v "^$")

echo -e "$out" | tac | dmenu -b -p 'Recent messages:' | xsel -i
echo -e "$out" >> ~/.i3/tempirc/${server}.out
