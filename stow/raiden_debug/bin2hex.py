#!/usr/bin/env python3
import fileinput
import re

def bin2hex(match):
    return '0x' + eval(match.group().replace('\\\\', '\\')).hex()

for line in fileinput.input():
    print(re.sub(r"b'.+?'", bin2hex, line), end='')
