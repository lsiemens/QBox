import h5py
import numpy
from matplotlib import pyplot

fname = "data.h5"
hdf5 = h5py.File(fname, "r")
group = hdf5["Run0"]
numberOfStates = group.attrs["numberOfStates"]
maxNumberOfStates = group.attrs["maxNumberOfStates"]
resolution = group.attrs["resolution"]
length = group.attrs["length"]
mass = group.attrs["mass"]
data = group["states"]
energyLevels = group["energyLevels"]

print(numberOfStates, maxNumberOfStates, resolution, length, mass)
print(type(data), data.shape, data.dtype, data.chunks)

pyplot.imshow(group["potential"])
pyplot.show()

data = numpy.array(data)
energyLevels = numpy.array(energyLevels)
for i in range(numberOfStates):
    print("Energy:", energyLevels[i])
    pyplot.imshow(data[:,:,i]**2)
    pyplot.show()
