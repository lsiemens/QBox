import numpy
import scipy.ndimage
from matplotlib import pyplot

import QBox


solver = QBox.Analytic(1.0, 800, path="well_0_low.pk")
#V = 0.005*(1.0 - solver.Y)

#V = solver.Y + 1.5*solver.X**2 - 0.8 + 0.05*0
#V[V<0] = 0
#V[V>0] = 1.0
#V = V + 0.005*(1.0 - solver.Y)
#V[V>1.0] = 1.0
#V = scipy.ndimage.gaussian_filter(V, sigma=0.5)
##rescale potential
#V = ((50 - 1)/2.0)**2*V

#pyplot.imshow(V)
#pyplot.show()
#solver.set_potential(V)

#solver.load()

#for _ in range(30):
solver.find_quantum_state(1, error_level=2.0E-2, max_rounds=50)

for energy, state in zip(solver.Energy_levels, solver.States):
    print(energy, "saved")
    print(solver.get_energy(state))
    print(solver.get_energy_new(state))
    print("")
#    QBox.plot(state)
