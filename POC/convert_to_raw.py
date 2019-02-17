import pickle
import numpy

import QBox

path = "./well_1_low.pk"
solver = QBox.QBox(1.0, 50, path=path)
solver.load()
solver.bsave("wellLow.raw")
