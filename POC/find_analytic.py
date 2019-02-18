import numpy
import scipy.ndimage
from matplotlib import pyplot

import QBox


solver = QBox.Analytic(10.0, 400, path="well_0_low.pk", isBox=False)

solver.find_quantum_state(100, error_level=2.0E-5, max_rounds=100)

for state in solver.States[80:]:
    QBox.plot(state)

