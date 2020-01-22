import h5py
import numpy
from matplotlib import pyplot

fname = "data.h5"
resolution = 64
length = 2.0
mass = 1.0
hdf5 = h5py.File(fname, "w")

run0 = hdf5.create_group("Run0")
run0.attrs["numberOfStates"] = 0
run0.attrs["maxNumberOfStates"] = -1
run0.attrs["resolution"] = resolution
run0.attrs["length"] = length
run0.attrs["mass"] = mass

potential = numpy.zeros(shape=(resolution, resolution), dtype=numpy.float64)
x = numpy.linspace(-length/2, length/2, resolution)
y = numpy.linspace(-length/2, length/2, resolution)
dx = numpy.mean(x[1:] - x[:-1])
X, Y = numpy.meshgrid(x, y)

potential = 0.0*(X**2 + Y**2)

run0_potential = run0.create_dataset("potential", (resolution, resolution), dtype=numpy.float64)
run0_potential[:, :] = potential[:, :]
