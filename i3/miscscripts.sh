#!/bin/sh

if [ -f $HOME/.config/dmenurc ]; then
	source $HOME/.config/dmenurc
else
	DMENU="dmenu -b -fn 'Terminus-10' -sf green -sb red -nf #000000 -nb #ffffff"
fi

function mpvplay {
	mpv $(xsel -o | $DMENU -p "Play with mpv:") > ~/.i3mpvlog
}

function dcalc {
	xsel -o | $DMENU -p "Calculate:" | python $HOME/.i3/pycalc.py | $DMENU -p "Result:" | xsel -i
}

function raisevol {
	amixer sset Master $(echo "3" | $DMENU -p "Raise volume:")%+
}

function lowervol {
	amixer sset Master $(echo "3" | $DMENU -p "Lower volume:")%-
}

function togglevol {
	amixer sset Master toggle
}

$1
