#! /usr/bin/env python
import fileinput, sys, re

block=[]
nonN=re.compile('[^N\n]')
for line in fileinput.input():
    if line.startswith('>'):
        if len(block)==1 or any(map(nonN.search, block[1:])):
            sys.stdout.writelines(block)
        block=[line]
    else:
        block.append(line)
if len(block)==1 or any(map(nonN.search, block[1:])):
    sys.stdout.writelines(block)
