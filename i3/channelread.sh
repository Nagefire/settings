#!/bin/sh

#Get server and channel for reading
server=$(ls ~/irc/ | grep -v "in$" | dmenu -b -p "Server channel is on:")
channel=$(ls ~/irc/$server | grep -v "in$" | grep -v "out$" | dmenu -b -p "What channel to read?")

#Make sure the persistent exists for grep
mkdir ~/.i3/tempirc/$server -p
touch ~/.i3/tempirc/$server/$channel

#Add each line of the persistent file to $togrep
togrep=$(cat ~/.i3/tempirc/$server/$channel)

if [ "$togrep" != "" ]; then
	#If $togrep has stuff in it, set $out to be every line that does not match $togrep
	out=$(grep -F -v "$togrep" ~/irc/$server/$channel/out)
else
	#If $togrep is empty, $out is every line
	out=$(cat ~/irc/$server/$channel/out)
fi

#Remove empty lines
out=$(echo -e "$out" | grep -v "^$")

echo "$out"

#Set the correct order for dmenu, add to persistent file
echo -e "$out" | tac | dmenu -b -p "Recent msgs from $server/$channel" | xsel -i
echo -e "$out"  >> ~/.i3/tempirc/$server/$channel
