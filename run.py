#!/usr/bin/env python3

import sys

import json
import pathlib
import platform
import shutil
import subprocess

NODE_DIR = pathlib.Path(__file__).parent

if __name__ == '__main__':
    # choose text based on executable name
    name = pathlib.Path(sys.argv[0]).stem
    if name == 'dimensions':
        text = None
    elif name == 'hostname':
        text = [[platform.node().split('.')[0]]]
    else:
        text = [line.split(' ') for line in '\n'.join(sys.argv[1:]).split('\n')]
    # copy dependencies into the node directory because some info-beamer versions don't support symlinks
    shutil.copy2('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', NODE_DIR / 'dejavu_sans.ttf')
    # write formatted text
    with (NODE_DIR / 'data.json').open('w') as data_f:
        json.dump(text, data_f)
    # run node
    popen = subprocess.Popen(['info-beamer', str(NODE_DIR)])
    sys.exit(popen.wait())
