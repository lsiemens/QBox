import QBHD
from matplotlib import pyplot

fname = "data.h5"
resolution = 128
numberOfGrids = 3
maxNumberOfStates = -1
isPeriodicBoundary = False
length = 10.0
mass = 1.0
biasEnergy = 0.0 # use for negative potentials

run = QBHD.create(fname, resolution, length)
run.maxNumberOfStates = maxNumberOfStates
run.numberOfGrids = numberOfGrids
run.isPeriodicBoundary = isPeriodicBoundary
run.mass = mass
run.biasEnergy = biasEnergy
run.targetEvolutionTime = run.evolutionTimeCalculator(1.4, 32)

potential = (run.X**2 + run.Y**2)
run.potential = potential

run.save()
