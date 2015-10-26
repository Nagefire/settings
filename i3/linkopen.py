#!/bin/python

import re
import subprocess
from subprocess import Popen
p = Popen(["xsel", "-o"], stdout=subprocess.PIPE)
output, err = p.communicate()
out = str(output).replace("b'", "").replace("\\n'", "")
words = out.split(" ")

p = re.compile(r"^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?")
for word in words:
	#print(word)
	#print(p.findall(word))
	if p.match(word) != None:
	#	print(word)
		subprocess.call(["xdg-open", word])
