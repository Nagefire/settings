#!/bin/sh

#List of notifies
notifies=""

#Go through every server
while read server; do
	if [ "$(cat ~/irc/$server/out)" != "$(touch ~/.i3/tempirc/${server}.out; cat ~/.i3/tempirc/${server}.out)" ]; then
		if [ "$notifies" != "" ]; then
			notifies=$notifies"\n"$server
		else
			notifies=$server
		fi
	fi
	#Go through every connection in the server
	while read conn; do
		if [ "$conn" != "" ]; then
			if [ "$(cat ~/irc/$server/$conn/out)" != \
			   "$(mkdir -p ~/.i3/tempirc/$server; touch ~/.i3/tempirc/$server/$conn; cat ~/.i3/tempirc/$server/$conn)" ]; then
				notifies=$notifies"\n"$conn
			fi
		fi
	done <<< "$(ls ~/irc/$server | grep -v 'in$' | grep -v 'out$' | grep -v '^$')"
done <<< "$(ls ~/irc/)"

notifies=$(echo -e "$notifies" | grep -v "^$")
echo -e $notifies | sed "s/ /\n/g" | dmenu -b -p "You have a message in:"
