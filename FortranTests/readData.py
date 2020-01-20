import h5py
import numpy
from matplotlib import pyplot

fname = "data.h5"
hdf5 = h5py.File(fname, "r")
group = hdf5["Run0"]
resolution = group.attrs["resolution"]
numberOfStates = group.attrs["numberOfStates"]
data = group["states"]

print(resolution, numberOfStates)
print(type(data), data.shape, data.dtype, data.chunks)

data = numpy.array(data)
for i in range(numberOfStates):
    pyplot.imshow(data[:,:,i])
    pyplot.show()
