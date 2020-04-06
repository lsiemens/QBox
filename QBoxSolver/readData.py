#!/usr/bin/env python3

import QBHD
from matplotlib import pyplot

fname = "data.h5"
run = QBHD.load(fname)

print(run.numberOfStates, run.maxNumberOfStates, run.resolution, run.length, run.mass, run.isPeriodicBoundary)
print(type(run.states), run.states.shape, run.states.dtype, run.states.chunks)

pyplot.imshow(run.potential)
pyplot.show()

pyplot.bar(range(run.numberOfStates), run.energyLevels)
pyplot.show()

for i in range(run.numberOfStates):
    print("State:", i, "Energy:", run.energyLevels[i])
    pyplot.plot(run.states[:, run.resolution//2, i])
    pyplot.plot(run.states[run.resolution//2, :, i])
    pyplot.plot(run.states[:, run.resolution//3, i])
    pyplot.plot(run.states[run.resolution//3, :, i])
    pyplot.show()
    pyplot.imshow(run.states[:,:,i]**2)
    pyplot.show()
