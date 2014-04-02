#!/usr/bin/python3
try:
	import yaml
except:
	print("Needs python3-yaml")
	exit(1)

import json, plistlib

name = 'Honey.tmLanguage'
plistlib.writePlist(yaml.load(open(name + '.yaml')), name)
