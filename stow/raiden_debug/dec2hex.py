#!/usr/bin/env python3
import fileinput
import re

for line in fileinput.input():
    print(re.sub(r"[0-9]+", lambda match: '0x%x' % int(match.group()), line), end='')
