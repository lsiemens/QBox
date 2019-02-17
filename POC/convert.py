#!/usr/bin/env python3

""" 
Usage:
  convert.py SOURCE DEST [options]
  convert.py -h | --help

Convert file from format readable by POC tools to format readable by GPOC.

Arguments:
  SOURCE    source POC readable file (python pickle file)
  DEST      destination GPOC readable file (binary data file)

Options:
  -v --verbose     explain what is being done
  -h --help         display this help and exit

"""

import QBox
import docopt

if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    source = arguments["SOURCE"]
    target = arguments["DEST"]
    verbose = arguments["--verbose"]
    solver = QBox.QBox(1.0, 2, path=source)
    solver.load(verbose=verbose)
    solver.bsave(target, verbose=verbose)
