#!/bin/sh

if [ -f $HOME/.config/dmenurc ]; then
	source $HOME/.config/dmenurc
else
	DMENU="dmenu -fn 'Terminus-10' -sf green -sb red -nf #000000 -nb #ffffff -b"
fi

function steam {
	app=$(ls ~/Games/steam/ | sed "s/\.desktop//" | $DMENU -p "Steam game:")
	cat "${HOME}/Games/steam/${app}.desktop" | grep "Exec" | sed "s/Exec=//" | sh -s
}

function nonsteam {
	app=$(ls ~/Games/nonsteam | sed "s/\.desktop//" | $DMENU -b -p "Game:")
	cat "${HOME}/Games/nonsteam/${app}.desktop" | grep "Exec" | sed "s/Exec=//" | sh -s
}

$1
