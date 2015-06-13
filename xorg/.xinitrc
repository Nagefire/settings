pulseaudio -D
urxvtd &

#X config
setxkbmap -variant colemak
xbindkeys
xautolocker -locker i3lock -time 7 -corners 0-00 &
xset -dpms
xset s off
xrdb merge ~/.Xresources

#start dm
startlxde
