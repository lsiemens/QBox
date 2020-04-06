import h5py
import numpy

class QBHD:
    _defaultMaxNumberOfStates = -1
    _defaultNumberOfGrids = 3
    _defaultIsPeriodicBoundary = False
    _defaultMass = 1.0
    _defaultbiasEnergy = 0.0

    def __init__(self, fname):
        self.fname = fname
        self.hdf5 = None

        self._writeProtect = False

        self._numberOfStates = None     # read only
        self._maxNumberOfStates = None
        self._resolution = None         # write once
        self._numberOfGrids = None
        self._isPeriodicBoundary = None # write once
        self._length = None             # write once
        self._mass = None               # write once
        self._biasEnergy = None         # write once
        self._targetEvolutionTime = None

        self._potential = None          # write once
        self._states = None             # read only
        self._energyLevels = None       # read only

        self._x, self._y = None, None   # read only
        self._dx = None                 # read only
        self._X, self._Y = None, None   # read only

    @property
    def numberOfStates(self):
        return self._numberOfStates

    @property
    def maxNumberOfStates(self):
        return self._maxNumberOfStates

    @maxNumberOfStates.setter
    def maxNumberOfStates(self, maxNumberOfStates):
        self._maxNumberOfStates = maxNumberOfStates

    @property
    def resolution(self):
        return self._resolution

    @resolution.setter
    def resolution(self, resolution):
        if not self._writeProtect:
            self._resolution = resolution
        else:
            raise AttributeError("can't overwrite value on file")

    @property
    def numberOfGrids(self):
        return self._numberOfGrids

    @numberOfGrids.setter
    def numberOfGrids(self, numberOfGrids):
        self._numberOfGrids = numberOfGrids

    @property
    def isPeriodicBoundary(self):
        return self._isPeriodicBoundary

    @isPeriodicBoundary.setter
    def isPeriodicBoundary(self, isPeriodicBoundary):
        if not self._writeProtect:
            self._isPeriodicBoundary = isPeriodicBoundary
        else:
            raise AttributeError("can't overwrite value on file")

    @property
    def length(self):
        return self._length

    @length.setter
    def length(self, length):
        if not self._writeProtect:
            self._length = length
        else:
            raise AttributeError("can't overwrite value on file")

    @property
    def mass(self):
        return self._mass

    @mass.setter
    def mass(self, mass):
        if not self._writeProtect:
            self._mass = mass
        else:
            raise AttributeError("can't overwrite value on file")

    @property
    def biasEnergy(self):
        return self._biasEnergy

    @biasEnergy.setter
    def biasEnergy(self, biasEnergy):
        if not self._writeProtect:
            self._biasEnergy = biasEnergy
        else:
            raise AttributeError("can't overwrite value on file")

    @property
    def targetEvolutionTime(self):
        return self._targetEvolutionTime

    @targetEvolutionTime.setter
    def targetEvolutionTime(self, targetEvolutionTime):
        self._targetEvolutionTime = targetEvolutionTime

    @property
    def potential(self):
        return self._potential + self.biasEnergy

    @potential.setter
    def potential(self, potential):
        if not self._writeProtect:
            self._potential = potential
        else:
            raise AttributeError("can't overwrite value on file")

    @property
    def states(self):
        return self._states

    @property
    def energyLevels(self):
        return self._energyLevels + self.biasEnergy

    @property
    def x(self):
        return self._x

    @property
    def y(self):
        return self._y

    @property
    def dx(self):
        return self._dx

    @property
    def X(self):
        return self._X

    @property
    def Y(self):
        return self._Y


    def evolutionTimeCalculator(self, deltaE, halfLives):
        return halfLives*numpy.log(2)/deltaE

    def _create(self, resolution, length):
        self._writeProtect = False

        self._numberOfStates = 0
        self._maxNumberOfStates = self._defaultMaxNumberOfStates
        self._resolution = resolution
        self._numberOfGrids = self._defaultNumberOfGrids
        self._isPeriodicBoundary = self._defaultIsPeriodicBoundary
        self._length = length
        self._mass = self._defaultMass
        self._biasEnergy = self._defaultbiasEnergy

        self._targetEvolutionTime = self.evolutionTimeCalculator((numpy.pi/self.length)**2/self.mass, 32)

        self._potential = numpy.zeros(shape=(self.resolution, self.resolution), dtype=numpy.float64)
        self._states = None
        self._energyLevels = None

        self._x = numpy.linspace(-self.length/2, self.length/2, self.resolution)
        self._y = numpy.linspace(-self.length/2, self.length/2, self.resolution)
        self._dx = numpy.mean(self.x[1:] - self.x[:-1])
        self._X, self._Y = numpy.meshgrid(self.x, self.y)

    def _load(self):
        self.hdf5 = h5py.File(self.fname, "a")
        group = self.hdf5["Run0"]

        self._writeProtect = True

        self._numberOfStates = group.attrs["numberOfStates"]
        self._maxNumberOfStates = group.attrs["maxNumberOfStates"]
        self._resolution = group.attrs["resolution"]
        self._numberOfGrids = group.attrs["numberOfGrids"]
        self._isPeriodicBoundary = bool(group.attrs["isPeriodicBoundary"])
        self._length = group.attrs["length"]
        self._mass = group.attrs["mass"]
        self._biasEnergy = group.attrs["biasEnergy"]
        self._targetEvolutionTime = group.attrs["targetEvolutionTime"]

        self._potential = numpy.array(group["potential"])
        if "states" in group.keys():
            self._states = group["states"]
        else:
            self._states = None

        if "energyLevels" in group.keys():
            self._energyLevels = numpy.array(group["energyLevels"])
        else:
            self._energyLevels = None

        self._x = numpy.linspace(-self.length/2, self.length/2, self.resolution)
        self._y = numpy.linspace(-self.length/2, self.length/2, self.resolution)
        self._dx = numpy.mean(self.x[1:] - self.x[:-1])
        self._X, self._Y = numpy.meshgrid(self.x, self.y)

    def save(self):
        if self.hdf5 is None:
            self.hdf5 = h5py.File(self.fname, "w")
            group = self.hdf5.create_group("Run0")
        else:
            group = self.hdf5["Run0"]

        group.attrs["numberOfStates"] = self.numberOfStates
        group.attrs["maxNumberOfStates"] = self.maxNumberOfStates
        group.attrs["resolution"] = self.resolution
        group.attrs["numberOfGrids"] = self.numberOfGrids
        group.attrs["isPeriodicBoundary"] = int(self.isPeriodicBoundary)
        group.attrs["length"] = self.length
        group.attrs["mass"] = self.mass
        group.attrs["biasEnergy"] = self.biasEnergy
        group.attrs["targetEvolutionTime"] = self.targetEvolutionTime

        if "potential" in group.keys():
            group_potential = group["potential"]
        else:
            group_potential = group.create_dataset("potential", (self.resolution, self.resolution), dtype=numpy.float64)
        group_potential[:, :] = self.potential[:, :]

def load(fname):
    data = QBHD(fname)
    data._load()
    return data

def create(fname, resolution=128, length=10.0):
    data = QBHD(fname)
    data._create(resolution, length)
    return data
