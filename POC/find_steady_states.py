import numpy
import scipy.ndimage
from matplotlib import pyplot

import QBox


solver = QBox.QBox(1.0, 200, path="well_2.pk")
#V = 0.005*(1.0 - solver.Y)

#V = solver.Y + 1.5*solver.X**2 - 0.8 + 0.05*0
#V[V<0] = 0
#V[V>0] = 1.0
#V = V + 0.005*(1.0 - solver.Y)
#V[V>1.0] = 1.0
#V = scipy.ndimage.gaussian_filter(V, sigma=2)

#pyplot.imshow(V)
#pyplot.show()
#solver.set_potential(V)
solver.load()

for _ in range(100):
    solver.find_quantum_state(1, error_level=2.0E-5, max_rounds=50)

for state in solver.States:
    QBox.plot(state)

