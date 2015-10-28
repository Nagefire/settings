#!/bin/sh

templog=~/.dmenuirc/tempirc
fulllog=~/.dmenuirc/logs
thisloc=~/.i3/dmenuirc.sh

mkdir -p $templog
mkdir -p $fulllog
mkdir -p ~/.dmenuirc

function channelfix {
	server=$(ls ~/irc/ | egrep -v "^in$|^out$|.\.nick$" | dmenu -b -p "Server channel is on:")
	channel=$(ls ~/irc/$server/ | egrep -v "^out$|^in$" | dmenu -b -p "Channel:")
	cat ~/irc/$server/$channel/out > $templog/$server/$channel
}

function notify {
	#List of notifies
	notifies=""
	
	#Go through every server
	while read server; do
		if [ "$(cat ~/irc/$server/out)" != "$(touch $templog/${server}.out; cat $templog/${server}.out)" ]; then
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
				   "$(mkdir -p $templog/$server; touch $templog/$server/$conn; cat $templog/$server/$conn)" ]; then
					notifies=$notifies"\n"$server"/"$conn
				fi
			fi
		done <<< "$(ls ~/irc/$server | egrep -v 'in$|out$|.\.nick$|^$')"
	done <<< "$(ls ~/irc/ | egrep -v '^in$|^out$|.\.nick')"
	
	notifies=$(echo -e "$notifies" | grep -v "^$")
	echo -e $notifies | sed "s/ /\n/g" | dmenu -b -p "You have a message in:"
}

function perschan {
	server=$(ls $templog/ | egrep -v ".\.out" | dmenu -b -p "Server channel is on:")
	channel=$(ls $templog/$server/ | grep -v "\!me.out" | dmenu -b -p "What channel to read?")
	recent=$(cat $templog/$server/$channel | tac)
	echo "$recent" | grep -v "^$" | dmenu -b -p "Msgs from $server/$channel" | xsel -i
}

function serverread {
	server=$(ls ~/irc/ | egrep -v "^in$|^out$|.\.nick" | dmenu -b -p "Choose server to read from")
	
	touch $templog/${server}.out
	
	togrep=$(cat $templog/${server}.out)
	if [ "$togrep" != "" ]; then
		out=$(grep -F -v "$togrep" ~/irc/$server/out)
	else
		out=$(cat ~/irc/$server/out)
	fi
	
	out=$(echo -e "$out" | grep -v "^$")
	
	echo -e "$out" | tac | dmenu -b -p 'Recent messages:' | xsel -i
	echo -e "$out" >> $templog/${server}.out
}

function chanmesg {
	server=$(ls ~/irc/ | egrep -v "^in$|^out$|.\.nick" | dmenu -b -p "Server of channel:")
	channel=$(ls ~/irc/$server/ | egrep -v "in$|out$" | dmenu -b -p "Channel:")
	msg=$(xsel -o | dmenu -b -p "Msg to $channel:")
	echo "$msg" >> ~/irc/$server/$channel/in
}

function channelread {
	#Get server and channel for reading
	server=$(ls ~/irc/ | egrep -v "^in$|^out$|.\.nick" | dmenu -b -p "Server channel is on:")
	channel=$(ls ~/irc/$server | egrep -v "in$|out$" | dmenu -b -p "What channel to read?")
	
	#Make sure the persistent exists for grep
	mkdir $templog/$server -p
	touch $templog/$server/$channel
	
	#Add each line of the persistent file to $togrep
	togrep=$(cat $templog/$server/$channel)
	
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
	echo -e "$out"  >> $templog/$server/$channel
}

function nickmsg {
	server=$(ls ~/irc/ | egrep -v "in$|out$|.\.nick" | dmenu -b -p "Server channel is on:")
	channel=$(ls ~/irc/$server/ | egrep -v "^in$|^out$|^$" | dmenu -b -p "Channel user is on: ")
	echo "/names" >> ~/irc/$server/in
	nicks=$(tac ~/irc/$server/out | grep -m 1 "= $channel")
	echo "$nicks"
	nicks=$(echo "$nicks" | sed -re "s/^[0-9]+-[0-9]+-[0-9]+ [0-9]+:[0-9]+ = $channel //g" | sed "s/ /\n/g")
	echo -e "$nicks" | dmenu -b -p "Tab complete a nick and type message:" >> ~/irc/$server/$channel/in
}

function persserv {
	server=$(ls $templog/ | egrep ".\.out|^in$|^out$" | sed "s/\.out//g" | dmenu -b -p "Choose server to read from")
	touch $templog/${server}.out
	recent=$(cat $templog/${server}.out | tac)
	echo "$recent" | grep -v "^$" | dmenu -b -p 'Msgs from $server:' | xsel -i
}

function serverfix {
	server=$(ls ~/irc/ | egrep -v "^in$|^out$|.\.nick" | dmenu -b -p "Server:")
	cat ~/irc/$server/out > $templog/${server}.out
}

function serverlist {
	ls ~/irc/ | egrep -v "^in$|^out$|.\.nick" | dmenu -b -p "Servers connected to:"
}

function channellist {
	ls ~/irc/$(ls ~/irc/ | egrep -v "^in$|^out$|.\.nick" | dmenu -b -p "List channels from:")/ | egrep -v "^in$|^out$" | dmenu -b -p "Channels connected to:"
}

function servermessage {
	server=$(ls ~/irc/ | egrep -v "^in$|^out$|.\.nick" | dmenu -b -p "Server to send to:")
	xsel -o | dmenu -b -p "Sever message:" >> ~/irc/$server/in
}

function connect {
	if [ "$1" == "chan" ]; then
		while true; do
			if [ -w ~/irc/$2/in ]; then
				break
			fi
			sleep 1
		done
		echo "/j $3 $4" >> ~/irc/$2/in
		while true; do
			chan=$(cat ~/irc/$2/out | grep "$3")
			if [ "$chan" != "" ]; then
				break;
			fi
			echo "/j $3 $4" >> ~/irc/$2/in
			sleep 2
		done
	elif [ "$1" == "" ]; then
		server=$(xsel -o | dmenu -b -p "Connect to:")
		port=$(echo "6667" | dmenu -b -p "Port:")
		nick=$(echo "$USER" | dmenu -b -p "Nick:")
	elif [ "$2" == "" ]; then
		server=$1
		port=$(echo "6667" | dmenu -b -p "Port:")
		nick=$(echo "$USER" | dmenu -b -p "Nick:")
	elif [ "$3" == "" ]; then
		server=$1
		port=$2
		nick=$(echo "$USER" | dmenu -b -p "Nick:")
	else
		server=$1
		port=$2
		nick=$3
	fi
	ii -s "$server" -p "$port" -n "$nick" &
	mkdir -p ~/irc/$server
	echo "$nick" > ~/irc/${server}.nick
}

function logdump {
	mkdir -p $fulllog
	cp $templog/* $fulllog -rf
}

function loadautorun {
	while read line; do
		line=$(echo "$line" | grep -v "^#")
		if [ "$line" != "" ]; then
			connect $line
		fi
	done < $1
}

function startup {
	pkill ii >> ~/.dmenuirc/ii.log
	rm -rf $templog/*
	rm -rf ~/irc/*
	loadautorun $1
}

$1 $2 $3 $4 $5 $6 $7 $8 $9
