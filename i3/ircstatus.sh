#!/bin/sh
templog=~/.dmenuirc/tempirc
fulllog=~/.dmenuirc/logs

while [[ "" == "" ]]; do
	#List of notifies
	notifies=""
	
	#Go through every server
	while read server; do
		if [ "$(cat ~/irc/$server/out)" != "$(touch $templog/${server}.out; cat $templog/${server}.out)" ]; then
			if [ "$notifies" != "" ]; then
				notifies=$notifies" | "$server
			else
				notifies=$server
			fi
		fi
		#Go through every connection in the server
		while read conn; do
			if [ "$conn" != "" ]; then
				if [ "$(cat ~/irc/$server/$conn/out)" != \
				   "$(mkdir -p $templog/$server; touch $templog/$server/$conn; cat $templog/$server/$conn)" ]; then
					notifies=$notifies" | "$server"/"$conn
				fi
			fi
		done <<< "$(ls ~/irc/$server | egrep -v 'in$|out$|.\.nick$|^$')"
	done <<< "$(ls ~/irc/ | egrep -v '^in$|^out$|.\.nick')"
	
	notifies=$(echo -e "$notifies")
	if [[ "$notifies" == "" ]]; then
		i3-msg "bar mode invisible dmenuirc"
		echo ""
	else
		i3-msg "bar mode dock dmenuirc"
		echo "$notifies"
	fi
	sleep 1
done
