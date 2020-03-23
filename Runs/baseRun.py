import h5py
import numpy
import shutil
from pathlib import Path
import subprocess
from matplotlib import pyplot

class baseRun:
    def __init__(self, solverPath, path="./"):
        self.path = path + "/"
        self.solverPath = solverPath + "/"
        self.fname = "data.h5"

        self.resolution = 128
        self.numberOfGrids = 3
        self.maxNumberOfStates = -1

        self.targetEvolutionTime = None
        self.isPeriodicBoundary = False
        self.length = 1.0
        self.mass = 1.0
        self.biasEnergy = 0.0

        # initalise targetEvolutionTime, isPeriodicBoundary, length, mass
        self.initalize()

        self.potential = numpy.zeros(shape=(self.resolution, self.resolution), dtype=numpy.float64)
        self.x = numpy.linspace(-self.length/2, self.length/2, self.resolution)
        self.y = numpy.linspace(-self.length/2, self.length/2, self.resolution)
        self.dx = numpy.mean(self.x[1:] - self.x[:-1])
        self.X, self.Y = numpy.meshgrid(self.x, self.y)

    def run(self):
        Path(self.path).mkdir(parents=True, exist_ok=True)
        hdf5 = h5py.File(self.path + self.fname, "w")
        run0 = hdf5.create_group("Run0")

        run0.attrs["numberOfStates"] = 0
        run0.attrs["maxNumberOfStates"] = self.maxNumberOfStates
        run0.attrs["resolution"] = self.resolution
        run0.attrs["numberOfGrids"] = self.numberOfGrids
        run0.attrs["isPeriodicBoundary"] = int(self.isPeriodicBoundary)
        run0.attrs["length"] = self.length
        run0.attrs["mass"] = self.mass
        run0.attrs["targetEvolutionTime"] = self.targetEvolutionTime

        # initalize potential, biasEnergy
        self.initalizePotential()
        run0.attrs["biasEnergy"] = self.biasEnergy

        run0_potential = run0.create_dataset("potential", (self.resolution, self.resolution), dtype=numpy.float64)
        run0_potential[:, :] = self.potential[:, :]

        shutil.copy2(self.solverPath + "QBoxSolver.out", self.path + "QBoxSolver.out")
        shutil.copy2(self.solverPath + "readData.py", self.path + "readData.py")

    def initalize(self):
        self.length = 10.0
        self.mass = 1.0
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(1.4, 32)
        print("uninitalized")

    def initalizePotential(self):
        self.potential = (self.X**2 + self.Y**2)
        print("uninitalized potential")

    def evolutionTimeCalculator(self, deltaE, halfLives):
        return halfLives*numpy.log(2)/deltaE
