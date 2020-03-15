import pickle
import numpy
from matplotlib import pyplot
from matplotlib import animation

import QBox

S0 = QBox.QBox(1.0, 200, path="well_0.pk")
S0.load()
S1 = QBox.QBox(1.0, 200, path="well_1.pk")
S1.load()
S2 = QBox.QBox(1.0, 200, path="well_2.pk")
S2.load()

solver = S0

#function = numpy.exp(-((solver.X)**2 + (solver.Y - 0.4)**2)/0.1)*numpy.exp(1.0j*(-solver.Y*0 + solver.X*4))
#function = QBox.normalize(function)
#phi_state = solver.calculate_constants(function)
phi_state = solver.normalize_constants([(0, 1.0)])
phi = solver.system(phi_state, 0)
print(phi_state)

#QBox.plot(function)
QBox.plot(phi)
#QBox.plot(function - phi)

max = (numpy.abs(solver.system(phi_state, 0))**2).max()
print(max)
for i in range(2400):
    t = 10*i
    pyplot.imshow(numpy.abs(solver.system(phi_state, t))**2)
    pyplot.clim(0, max)
#    pyplot.show()
    pyplot.savefig("./tmp/analize_" + str(i) + ".png", bbox_inches="tight")
    pyplot.clf()

    if i == (2400//6):
        phi = solver.system(phi_state, t)
        solver = S1
        phi_state = solver.calculate_constants(phi)
    elif i == 2*(2400//3):
        phi = solver.system(phi_state, t)
        solver = S2
        phi_state = solver.calculate_constants(phi)
    print(i)
