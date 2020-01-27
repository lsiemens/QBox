import h5py
import numpy
from matplotlib import pyplot

def evolutionTimeCalculator(deltaE, halfLives):
    return halfLives*numpy.log(2)/deltaE

fname = "data.h5"
resolution = 128
maxNumberOfStates = -1
targetEvolutionTime = evolutionTimeCalculator(1.4, 32)
length = 10.0
mass = 1.0
hdf5 = h5py.File(fname, "w")

run0 = hdf5.create_group("Run0")
run0.attrs["numberOfStates"] = 0
run0.attrs["maxNumberOfStates"] = maxNumberOfStates
run0.attrs["resolution"] = resolution
run0.attrs["length"] = length
run0.attrs["mass"] = mass
run0.attrs["targetEvolutionTime"] = targetEvolutionTime

potential = numpy.zeros(shape=(resolution, resolution), dtype=numpy.float64)
x = numpy.linspace(-length/2, length/2, resolution)
y = numpy.linspace(-length/2, length/2, resolution)
dx = numpy.mean(x[1:] - x[:-1])
X, Y = numpy.meshgrid(x, y)

potential = (X**2 + Y**2)

run0_potential = run0.create_dataset("potential", (resolution, resolution), dtype=numpy.float64)
run0_potential[:, :] = potential[:, :]
