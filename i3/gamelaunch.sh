#!/bin/sh

function steam {
	app=$(ls ~/Games/steam/ | sed "s/\.desktop//" | dmenu -b -p "Steam game:")
	cat "${HOME}/Games/steam/${app}.desktop" | grep "Exec" | sed "s/Exec=//" | sh -s
}

function nonsteam {
	app=$(ls ~/Games/nonsteam | sed "s/\.desktop//" | dmenu -b -p "Game:")
	cat "${HOME}/Games/nonsteam/${app}.desktop" | grep "Exec" | sed "s/Exec=//" | sh -s
}

$1
