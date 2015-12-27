#!/bin/bash

if [ -f "$HOME/.config/dmenurc" ]; then
	source "$HOME/.config/dmenurc"
else
	DMENU="dmenu -b -l 4 -fn 'Terminus-10' -sf green -sb red -nb #ffffff -nf #000000"
fi

function normal {
	commands="	0-9: Go to workspace 0-9 (0 is 10)
				Shift+0-9: Move active window to workspaces 0-9
				Enter: Open an urxvtc client
				Shift+Q: Kill current window
				d: Open dmenu_run
				h or left arrow: move focus to the left
				j or down arrow: move focus down
				k or up arrow: move focus up
				l or right arrow: move focus right
				Shift+h or Shift+left arrow: Move container left
				Shift+j or Shift+down arrow: Move container down
				Shift+k or Shift+up arrow: Move container up
				Shift+l or Shift+right arrow: Move container up
				n: Make splits be horizontal
				v: Make splits be vertical
				z: toggle fullscrean on container
				t: Make the container use a stacking layout
				w: Make the container use a tabbed layout
				e: Make the container use a split layout
				Shift+space: Toggle floating on container
				space: toggle focus between floating and tiling containers
				a: Focus on container parent
				Shift+D: Focus on container child
				\`: Go to a named workspace with a dmenu list
				~: Move container to named workspace witha dmenu list
				Shift+C: reload i3 config
				Shift+R: restart i3 in place
				Shift+E: logout popup
				r: enter resize mode
				m: play what's in xsel -o with mpv (dmenu launch)
				c: dmenu calculator
				u: raise volume (dmenu prompt for amount)
				i: lower volume (dmenu prompt for amount)
				y: toggle mute
				o: open a text file in vim
				Shift+M: enter mpd control mode
				p: enter dmenuirc mode
				s: enter dmenurss mode
				Shift-p: open link in xsel -o with xdg-open
				g: launch a steam game in ~/Games/steam
				Shift+G: launch a game in ~/Games/nonsteam
				f: launch dmenu file manager from $HOME
				F: launch dmenu file manager where it last left off
				x: jump to the newest urgent (red) window
				?: open this help in any mode"
	echo -e "$commands" | sed -r -e "s/\t//g" | $DMENU -p "Mod + "
}

function resize {
	commands="	h or left arrow: Shrink the left side of a window in by 1 unit
				j or down arrow: Shrink the bottom side of a window in by 1 unit
				k or up arrow: Shrink the top side of a window in by 1 unit
				l or right arrow: Shrink the right side of a window in by 1 unit
				To grow a window, do Shift+<key>. The directions are the same as above.
				Enter or escape: exit resize mode"
	echo -e "$commands" | sed -r -e "s/\t//g" | $DMENU -p "No prefix"
}

function mpd {
	commands="	l: load a playlist into mpd
				a: add a song to the current playlist
				p: set mpd to start playing
				n: Go to the next song in the playlist
				r: delete a playlist
				s: save the current playlist
				e: pause mpd
				y: toggle mpd between playing and being paused
				d: remove current song from playlist
				u: raise mpd volume
				i: lower mpd volume
				Shift+I: set mpd volume to a value
				v: get mpd version
				t: get mpd stats
				c: get info about the current song
				Shift+C: clear current playlist
				Shift+S: shuffle playlist
				Shift+R: toggle repeat
				Shift+A: Play a random song from current playlist
				Shift+P: Go to previous song in current playlist
				Shift+U: update mpd db (When new music is added to mpd directory
				Escape or enter: exit mpd mode"
	echo -e "$commands" | sed -r -e "s/\t//g" | $DMENU -p "No prefix"
}

function irc {
	commands="	l: list the servers
				c: get a list of channels connected to on a server
				s: send a server a message
				m: send a channel message
				r: read new items in a channel
				Shift+R: read new items in a server
				Shift+c: connect to a server
				p: read all messages recieved from a channel
				Shift+p: read all messages recieved from a server
				d: dump irc logs to persistent storage
				n: show what channels have new messages
				Shift+L: open a link in xsel -o with xdg-open
				Shift+N: List nicks in a channel and send a message
				f: fix notifications staying up on a channel
				Shift+f: fix notifications staying up on a server
				q: restart dmenuirc
				Escape or enter: exit irc mode"
	echo -e "$commands" | sed -r -e "s/\t//g" | $DMENU -p "No prefix"
}

function rss {
	commands="	r: read new items in a rss/atom feed
				p: read all items in a feed
				n: get what feeds have new items
				d: read description of a feed
				Escape or enter: exit rss mode"
	echo -e "$commands" | sed -r -e "s/\t//g" | $DMENU -p "No prefix"
}

$@
