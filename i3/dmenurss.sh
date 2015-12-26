#!/bin/bash

if [ -f "$HOME/.config/dmenurc" ]; then
	source $HOME/.config/dmenurc
else
	DMENU="dmenu -b -l 4 -fn 'Terminus-10' -sf green -sb red -nb #ffffff -nf #000000"
fi

readPath=$HOME/.dmenurss
rssPath=$HOME/rss

function readNewItems {
	feeds=$(ls $rssPath | grep -v " desc")
	tag=$(echo "$feeds" | $DMENU -p "Select feed to read from.")
	
	touch $readPath/$tag
	out=""
	while read line; do
		if ! grep -q "$line" "$readPath/$tag"; then
			out=$out"\n"$line
		fi
	done < "$rssPath/$tag"
	
	out=$(echo -e "$out" | grep -v "^$")
	
	items=()
	i=0
	while [ "$out" != "" ]; do
		tmp=$(echo "$out" | tail -n 1)
		if [ "$tmp" != "ITEMS" ]; then
			items[i]=${items[i]}"\n"$tmp
		else
			items[i]=${items[i]}"\n"
			i=$(($i+1))
		fi
		out=$(echo "$out" | tac | tail -n $(echo $(echo "$out" | wc -l)" - 1" | bc) | tac)
	done
	
	i=1
	titles=""
	while [ "$i" -le "$((${#items[@]} - 1))" ]; do
		titles=${titles}"\n"$(echo -e "${items[$i]}" | grep "title: " | sed "s/^title: //")
		i=$(($i+1))
	done
	
	chosen=$(echo -e "$titles" | grep -v "^$" | $DMENU -p "Items in feed: "$tag)
	
	if [[ "$chosen" == "" || "$chosen" == "\n" ]]; then
		return
	fi
	
	i=1
	while ! echo "${items[$i]}" | grep -q "$chosen"; do
		i=$(($i+1))
	done
	
	link=$(echo -e "${items[i]}" | grep -v "^$" | $DMENU)
	if echo "$link" | grep -q "link: "; then
		xdg-open $(echo "$link" | sed "s/link: //")
	fi
	echo "$link" | sed -r "s/^[^:]+: //" | xsel -i
	
	toPaste=$(echo -e "${items[i]}" | grep -v "^$")
	echo -e "$toPaste" >> $readPath/$tag
}

function readItems {
	feeds=$(ls $rssPath | grep -v " desc")
	tag=$(echo "$feeds" | $DMENU -p "Select feed to read from.")
	
	out=$(cat $rssPath/$tag)
	items=()
	i=0
	while [ "$out" != "" ]; do
		tmp=$(echo "$out" | tail -n 1)
		if [ "$tmp" != "ITEMS" ]; then
			items[i]=${items[i]}"\n"$tmp
		else
			items[i]=${items[i]}"\n"
			i=$(($i+1))
		fi
		out=$(echo "$out" | tac | tail -n $(echo $(echo "$out" | wc -l)" - 1" | bc) | tac)
	done
	
	i=1
	titles=""
	while [ "$i" -le "$((${#items[@]} + 1))" ]; do
		titles=${titles}"\n"$(echo -e "${items[$i]}" | grep "title: " | sed "s/^title: //")
		i=$(($i+1))
	done
	
	chosen=$(echo -e "$titles" | grep -v "^$" | $DMENU -p "Items in feed: "$tag)
	
	if [[ "$chosen" == "" || "$chosen" == "\n" ]]; then
		return
	fi
	
	i=1
	while ! echo "${items[$i]}" | grep -q "$chosen"; do
		i=$(($i+1))
	done
	
	link=$(echo -e "${items[$i]}" | grep -v "^$" | $DMENU)
	if echo "$link" | grep -q "^link: "; then
		xdg-open $(echo "$link" | sed "s/link: //")
	fi
	echo "$link" | sed -r "s/^[^:]+: //" | xsel -i
}

function readDesc {
	feeds=$(ls $rssPath | grep " desc" | sed "s/ desc//")
	tag=$(echo "$feeds" | $DMENU -p "Select feed to read from.")
	tag=$tag" desc"
	
	names=""
	descs=""
	
	
	touch "$rssPath/$tag"
	revFile=$(tac "$rssPath/$tag")
	
	while read line; do
		if ! echo -e "$names" | grep -q "$(echo "$line" | sed -r "s/:.+$//")"; then
			names=$names"\n"$(echo -e "$line" | sed -r "s/:.+$//")
			descs=$descs"\n"$line
		fi
	done <<< "$revFile"
	
	link=$(echo -e "$descs" | grep -v "^$" | tac | $DMENU)
	if echo "$link" | grep -q "^link: "; then
		xdg-open $(echo "$link" | sed "s/^link: //")
	fi
	echo "$link" | sed -r "s/^[^:]+: //" | xsel -i
}

function notify {
	alltags=$(ls $rssPath | grep -v " desc")
	
	notify=""
	for tag in $alltags; do
		touch "$readPath/$tag"
		while read line; do
			if [[ "$line" != "ITEMS" && "$line" != "" && "$line" != "\n" ]]; then
				tmpLine=$(echo "$line" | sed -e "s/\"/\\\"/g" -e "s/\#/\\\#/g")
				if ! fgrep -x -q "$tmpLine" "$readPath/$tag" && ! echo "$line" | fgrep -q "description:"; then
					notify=$(echo -e "$notify\n$tag")
					echo "$line"
					break
				fi
			fi
		done < "$rssPath/$tag"
	done
	
	echo -e "$notify" | grep -v "^$" | $DMENU
}

$1
