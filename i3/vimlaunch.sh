#!/bin/sh
com=`echo "" | dmenu -b -p "To open in vim:"`
urxvtc -e sh -c 'vim $com'
