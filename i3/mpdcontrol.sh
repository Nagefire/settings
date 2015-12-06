#!/bin/sh

if [ -f $HOME/.config/dmenurc ]; then
	source $HOME/.config/dmenurc
else
	DMENU="dmenu -b -fn 'Terminus-10' -sf green -sb red -nf #000000 -nb #ffffff"
fi

function load {
	mpc load $(mpc lsplaylist | $DMENU -p "Load playlist:")
}

function add {
	mpc add $(mpc listall | $DMENU -p "Add song to current playlist:")
}

function play {
	mpc play
}

function next {
	mpc next
}

function delete {
	mpc rm $(mpc lsplaylist | $DMENU -p "Delete playlist:")
}

function save {
	mpc save $($DMENU -noinput -p "Save playlist as:")
}

function pause {
	mpc pause
}

function toggle {
	mpc toggle
}

function rmsong {
	mpc del 0
}

function raisevol {
	mpc volume +$(echo "3" | $DMENU -p "Raise mpd volume by:")
}

function lowervol {
	mpc volume -$(echo "3" | $DMENU -p "Lower mpd volume by:")
}

function setvol {
	mpc volume $($DMENU -noinput -p "Set mpd volume to:")
}

function version {
	mpc version | $DMENU
}

function stats {
	mpc stats | $DMENU
}

function nope {
	mpc | $DMENU
}

function clear {
	mpc clear
}

function shuffle {
	mpc shuffle
}

function repeat {
	mpc repeat
}

function random {
	mpc random
}

function prev {
	mpc prev
}

function update {
	mpd update
}

$1
