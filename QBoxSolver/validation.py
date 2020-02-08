import h5py
import numpy
from matplotlib import pyplot

import QBox

class QData:
    def __init__(self, fname):
        self.fname = fname

        h5File = h5py.File(fname, "r")["Run0"]

        self.length = h5File.attrs["length"]
        self.mass = h5File.attrs["mass"]
        self.numberOfStates = h5File.attrs["numberOfStates"]
        self.resolution = h5File.attrs["resolution"]
        self.potential = h5File["potential"]
        self.States = numpy.transpose(h5File["states"], (2, 0, 1))
        self.Energy_levels = h5File["energyLevels"]

        self.dx = self.length/(self.resolution - 1)

    def projection(self, a, b):
        return numpy.sum(a*b)*self.dx**2

path_hdf5 = "data.h5"
FData = QData(path_hdf5)

#path_pickle = "T.h5"
#PData = QData(path_pickle)

path_pickle = "T.pk"
PData = QBox.QBox(1.0, 10, path=path_pickle)
PData.load()

numberOfStates = FData.numberOfStates

def proj(a, b):
    return FData.projection(a, b)

def projMatrix(statesA, statesB):
    num = len(statesA)
    mat = numpy.zeros((num, num))
    for i in range(num):
        for j in range(num):
            mat[i, j] = proj(statesA[i], statesB[j])
    return mat

def operator(data, vector):
    output = numpy.zeros(vector.shape)
    for i in range(len(data.Energy_levels)):
        output += data.Energy_levels[i]*data.States[i]*proj(data.States[i], vector)
    return output

print(projMatrix(PData.States, PData.States), "\n")
print(projMatrix(FData.States, FData.States), "\n")
print(projMatrix(PData.States, FData.States), "\n")

for i in range(numberOfStates):
    state = PData.States[i]
    e = FData.Energy_levels[i]
    e_prime = PData.Energy_levels[i]
    E = proj(state, operator(FData, state))
    E_prime = proj(state, operator(PData, state))
    E2 = proj(state, operator(FData, operator(FData, state)))
    E2_prime = proj(state, operator(PData, operator(PData, state)))

    Er = numpy.sqrt(numpy.abs(E2 - E**2))/E
    Er_prime = numpy.sqrt(numpy.abs(E2_prime - E_prime**2))/E_prime
    print(2*numpy.abs(E - E_prime)/(E + E_prime), Er + Er_prime)

for i in range(numberOfStates):
    a = PData.States[i]
    b = FData.States[i]
    pyplot.imshow(a - b)
    pyplot.show()
