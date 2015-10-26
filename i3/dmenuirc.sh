#!/bin/sh

function channelfix {
	server=$(ls ~/irc/ | grep -v "^in$" | dmenu -b -p "Server channel is on:")
	channel=$(ls ~/irc/$server/ | egrep -v "^out$|^in$" | dmenu -b -p "Channel:")
	cat ~/irc/$server/$channel/out > ~/.i3/tempirc/$server/$channel
}

function notify {
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
}

function perschan {
	server=$(ls ~/.i3/tempirc/ | egrep -v ".\.out" | dmenu -b -p "Server channel is on:")
	channel=$(ls ~/.i3/tempirc/$server/ | grep -v "\!me.out" | dmenu -b -p "What channel to read?")
	recent=$(cat ~/.i3/tempirc/$server/$channel | tac)
	echo "$recent" | grep -v "^$" | dmenu -b -p "Msgs from $server/$channel" | xsel -i
}

function serverread {
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
}

function chanmesg {
	server=$(ls ~/irc/ | grep -v "in$" | dmenu -b -p "Server of channel:")
	channel=$(ls ~/irc/$server/ | grep -v "in$" | grep -v "out$" | dmenu -b -p "Channel:")
	msg=$(xsel -o | dmenu -b -p "Msg to $channel:")
	echo "$msg" >> ~/irc/$server/$channel/in
}

function channelread {
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
	#Set the correct order for dmenu, add to persistent file
	echo -e "$out" | tac | dmenu -b -p "Recent msgs from $server/$channel" | xsel -i
	echo -e "$out"  >> ~/.i3/tempirc/$server/$channel
}

function nickmsg {
	server=$(ls ~/irc/ | grep -v "in$" | dmenu -b -p "Server channel is on:")
	channel=$(ls ~/irc/$server/ | grep -v "in$" | grep -v "out$" | grep -v "^$" | dmenu -b -p "Channel user is on: ")
	echo "/names" >> ~/irc/$server/in
	nicks=$(tac ~/irc/$server/out | grep -m 1 "= $channel")
	echo "$nicks"
	nicks=$(echo "$nicks" | sed -re "s/^[0-9]+-[0-9]+-[0-9]+ [0-9]+:[0-9]+ = $channel //g" | sed "s/ /\n/g")
	echo -e "$nicks" | dmenu -b -p "Tab complete a nick and type message:" >> ~/irc/$server/$channel/in
}

function persserv {
	server=$(ls ~/.i3/tempirc/ | egrep ".\.out" | grep -v "^in" | sed "s/\.out//g" | dmenu -b -p "Choose server to read from")
	touch ~/.i3/tempirc/${server}.out
	recent=$(cat ~/.i3/tempirc/${server}.out | tac)
	echo "$recent" | grep -v "^$" | dmenu -b -p 'Msgs from $server:' | xsel -i
}

function serverfix {
	server=$(ls ~/irc/ | grep -v "^in$" | dmenu -b -p "Server:")
	cat ~/irc/$server/out > ~/.i3/tempirc/${server}.out
}

function serverlist {
	ls ~/irc/ | grep -v "^in$" | dmenu -b -p "Servers connected to:"
}

function channellist {
	ls ~/irc/$(ls ~/irc/ | grep -v "^in$" | dmenu -b -p "List channels from:")/ | egrep -v "^in$|^out$" | dmenu -b -p "Channels connected to:"
}

function servermessage {
	server=$(ls ~/irc/ | grep -v "^in$" | dmenu -b -p "Server to send to:")
	xsel -o | dmenu -b -p "Sever message:" >> ~/irc/$server/in
}

function connect {
	server=$(xsel -o | dmenu -b -p "Connect to:")
	nick=$(echo $USER | dmenu -b -p "Nickname")
	port=$(echo "6667" | dmenu -b -p "Port:")
	ii -s "$server" -p "$port" -n "$nick"
}

function logdump {
	mkdir -p ~/.dmenuirclogs
	cp ~/.i3/tempirc/* ~/.dmenuirclogs -rf
}

$1
