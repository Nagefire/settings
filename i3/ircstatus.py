#!/bin/python
#This uses i3status to make dmenuirc notifications on i3bar
#To use you need to change the templog path and fifodir path to the ones in dmenuirc.sh
import subprocess
import sys
import time
import os

#For determining if we need to display the notification
templog="/home/aftix/.dmenuirc/tempirc"
fifodir="/home/aftix/irc"

#Get if we need an irc notify
notifyStr = ''
#First, get all the active servers in ~/irc/ (they are directories)
activeservers = []
for (dirpath, dirnames, filenames) in os.walk(fifodir):
	activeservers += dirnames
#See if the server fifo itself needs a notify. This can be done by seeing if the last lines of the fifo and log are different with tail
for server in activeservers:
	p = subprocess.Popen(["tail", "-n", "1", fifodir+"/"+server+"/out"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	fifoLast = (p.stdout.readline()).decode('utf-8')[:-1]
	#No need to terminate as tail does it itself
	#Now time to get the log's last one
	p = subprocess.Popen(["tail", "-n", "1", templog + "/" + server + ".out"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	logLast = (p.stdout.readline()).decode('utf-8')[:-1]
	#If they are not the same
	if not (logLast == fifoLast):
		notifyStr += " | " + server
#Now we need to add notifies for all channels / pms. We can go through the directories of all active servers and see their privmsg directories
activePMs = []
for server in activeservers:
	for (dirpath, dirnames, filenames) in os.walk(fifodir + "/" + server):
		#add active server to the front of the pms for file access
		for direct in dirnames:
			activePMs.append(server + "/" + direct)

#Do the same last line check on all pms
for pm in activePMs:
	p = subprocess.Popen(["tail", "-n", "1", fifodir+"/"+pm+"/out"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	fifoLast = (p.stdout.readline()).decode('utf-8')
	p = subprocess.Popen(["tail", "-n", "1", templog+"/"+pm], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	logLast = (p.stdout.readline()).decode('utf-8')
	if not (logLast == fifoLast):
		notifyStr += " | " + pm

#Print out the status + the notify
if notifyStr is None:
	print("")
else:
	print(notifyStr[3:])
sys.stdout.flush()
