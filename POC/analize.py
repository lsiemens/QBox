import pickle
import numpy
from matplotlib import pyplot
from matplotlib import animation

import QBox

path = "./well_1.pk"
solver = QBox.QBox(1.0, 200, path=path)
#solver = QBox.QBox(1.0, 200)
solver.load()

function = numpy.exp(-((solver.X)**2 + (solver.Y)**2)/0.4)*numpy.exp(1.0j*(-solver.Y*0 + solver.X*5))
function = QBox.normalize(function)
phi_state = solver.calculate_constants(function)

#print(phi_state)
for i, s in enumerate(solver.States):
    print(solver.get_energy(s))
    QBox.plot(s)
#QBox.plot(States[0])
#QBox.plot(States[-1])
#QBox.plot(function)
#QBox.plot(solver.system(phi_state, 0))
#QBox.plot(function - solver.system(phi_state, 0))

#fig = pyplot.figure()

#def animate(i):
#max = (numpy.abs(solver.system(phi_state, 0))**2).max()
#print(max)
#for i in range(2400):
#    pyplot.imshow(numpy.abs(solver.system(phi_state, 10*i))**2)
#    pyplot.clim(0, max)
#    pyplot.savefig("./tmp/analize_" + str(i) + ".png", bbox_inches="tight")
#    pyplot.clf()
#    print(i)

#anim = animation.FuncAnimation(fig, animate, frames=2400)
#pyplot.show()
#anim.save('test.mp4', fps=30)
