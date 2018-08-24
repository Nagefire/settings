urxvtd&

#X config
setxkbmap -variant colemak
setxkbmap -option compose:caps
xbindkeys
xautolock -locker "i3lock-fancy -p" -time 7 -corners 0-00 &
xset s off -dpms
xrdb merge ~/.Xresources

#start wm
exec i3
