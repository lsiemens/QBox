#!/usr/bin/env python3

import numpy
import baseRun

length = 20.0 # hartree length units
mass = 1 # hartree mass units
omega = 1
wallHeight = 50 # hartree energy units
wallThick = 0.075 # percentage of simulation
wallThin = 0.01 # percentage of simulation
slitWidth = 0.10 # percentage of simulation
isPeriodicPotential = False

class box(baseRun.baseRun):
    def initalize(self):
        self.length = length
        self.mass = mass
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.002, 32)

    def initalizePotential(self):
        self.potential = 0*self.X

class space(baseRun.baseRun):
    def initalize(self):
        self.length = length
        self.mass = mass
        self.isPeriodicBoundary = True
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.002, 32)

    def initalizePotential(self):
        self.potential = 0*self.X

class harmonic(baseRun.baseRun):
    def initalize(self):
        self.length = length
        self.mass = mass
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.02, 32)

    def initalizePotential(self):
        self.potential = (1/2)*self.mass*omega**2*(self.X**2 + self.Y**2)

class harmonicWall(baseRun.baseRun):
    def initalize(self):
        self.length = length
        self.mass = mass
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.02, 32)

    def initalizePotential(self):
        self.potential = (1/2)*self.mass*omega**2*(self.X**2 + self.Y**2)
        self.potential[self.resolution//2 - int(numpy.ceil(self.resolution*wallThin/2)):self.resolution//2 + int(numpy.ceil(self.resolution*wallThin/2)), :] += wallHeight

class wall(baseRun.baseRun):
    def initalize(self):
        self.length = length
        self.mass = mass
        self.isPeriodicBoundary = isPeriodicPotential
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.004, 32)

    def initalizePotential(self):
        self.potential = 0*self.X
        self.potential[self.resolution//2 - int(numpy.ceil(self.resolution*wallThin/2)):self.resolution//2 + int(numpy.ceil(self.resolution*wallThin/2)), :] += wallHeight

class harmonicSingleSlit(baseRun.baseRun):
    def initalize(self):
        self.length = length
        self.mass = mass
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.02, 32)

    def initalizePotential(self):
        self.potential = (1/2)*self.mass*omega**2*(self.X**2 + self.Y**2)
        self.potential[self.resolution//2 - int(numpy.ceil(self.resolution*wallThick//2)):self.resolution//2 + int(numpy.ceil(self.resolution*wallThick/2)), :self.resolution//2 - int(numpy.ceil(self.resolution*slitWidth//2))] += wallHeight
        self.potential[self.resolution//2 - int(numpy.ceil(self.resolution*wallThick//2)):self.resolution//2 + int(numpy.ceil(self.resolution*wallThick/2)), self.resolution//2 + int(numpy.ceil(self.resolution*slitWidth//2)):] += wallHeight

class singleSlit(baseRun.baseRun):
    def initalize(self):
        self.length = length
        self.mass = mass
        self.isPeriodicBoundary = isPeriodicPotential
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.01, 32)

    def initalizePotential(self):
        self.potential = 0*self.X
        self.potential[self.resolution//2 - int(numpy.ceil(self.resolution*wallThick//2)):self.resolution//2 + int(numpy.ceil(self.resolution*wallThick/2)), :self.resolution//2 - int(numpy.ceil(self.resolution*slitWidth//2))] += wallHeight
        self.potential[self.resolution//2 - int(numpy.ceil(self.resolution*wallThick//2)):self.resolution//2 + int(numpy.ceil(self.resolution*wallThick/2)), self.resolution//2 + int(numpy.ceil(self.resolution*slitWidth//2)):] += wallHeight

class harmonicDoubleSlit(baseRun.baseRun):
    def initalize(self):
        self.length = length
        self.mass = mass
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.02, 32)

    def initalizePotential(self):
        self.potential = (1/2)*self.mass*omega**2*(self.X**2 + self.Y**2)
        self.potential[self.resolution//2 - int(numpy.ceil(self.resolution*wallThick/2)):self.resolution//2 + int(numpy.ceil(self.resolution*wallThick/2)), :self.resolution//2 - 3*int(numpy.ceil(self.resolution*slitWidth/2))] += wallHeight
        self.potential[self.resolution//2 - int(numpy.ceil(self.resolution*wallThick/2)):self.resolution//2 + int(numpy.ceil(self.resolution*wallThick/2)), self.resolution//2 - int(numpy.ceil(self.resolution*slitWidth/2)):self.resolution//2 + int(numpy.ceil(self.resolution*slitWidth/2))] += wallHeight
        self.potential[self.resolution//2 - int(numpy.ceil(self.resolution*wallThick/2)):self.resolution//2 + int(numpy.ceil(self.resolution*wallThick/2)), self.resolution//2 + 3*int(numpy.ceil(self.resolution*slitWidth/2)):] += wallHeight

class doubleSlit(baseRun.baseRun):
    def initalize(self):
        self.length = length
        self.mass = mass
        self.isPeriodicBoundary = isPeriodicPotential
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.01, 32)

    def initalizePotential(self):
        self.potential = 0*self.X
        self.potential[self.resolution//2 - int(numpy.ceil(self.resolution*wallThick/2)):self.resolution//2 + int(numpy.ceil(self.resolution*wallThick/2)), :self.resolution//2 - 3*int(numpy.ceil(self.resolution*slitWidth/2))] += wallHeight
        self.potential[self.resolution//2 - int(numpy.ceil(self.resolution*wallThick/2)):self.resolution//2 + int(numpy.ceil(self.resolution*wallThick/2)), self.resolution//2 - int(numpy.ceil(self.resolution*slitWidth/2)):self.resolution//2 + int(numpy.ceil(self.resolution*slitWidth/2))] += wallHeight
        self.potential[self.resolution//2 - int(numpy.ceil(self.resolution*wallThick/2)):self.resolution//2 + int(numpy.ceil(self.resolution*wallThick/2)), self.resolution//2 + 3*int(numpy.ceil(self.resolution*slitWidth/2)):] += wallHeight

class hydrogenAtom(baseRun.baseRun):
    def initalize(self):
        self.length = length
        self.mass = mass
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.015, 32)

    def initalizePotential(self):
        self.potential = 0*self.X
        self.potential = - 1/numpy.sqrt(self.X**2 + self.Y**2)
        self.biasEnergy = numpy.min(self.potential)
        self.potential -= self.biasEnergy

class hydrogenMolecularIon(baseRun.baseRun):
    def initalize(self):
        self.length = 100.0
        self.mass = mass
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.005, 32)

    def initalizePotential(self):
        bondLength = 0.52
        r1 = numpy.sqrt((self.X - bondLength/2)**2 + self.Y**2)
        r2 = numpy.sqrt((self.X + bondLength/2)**2 + self.Y**2)
        self.potential = 0*self.X
        self.potential = - 1/r1 - 1/r2 + 1/bondLength
        self.biasEnergy = numpy.min(self.potential)
        self.potential -= self.biasEnergy

class lattice(baseRun.baseRun):
    def initalize(self):
        self.length = length
        self.mass = mass
        self.isPeriodicBoundary = True
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.0025, 32)

    def initalizePotential(self):
        n = 3
        smoothing = 0.2
        self.potential = -1/numpy.sqrt(numpy.sin(n*numpy.pi*self.X/self.length)**2 + numpy.sin(n*numpy.pi*self.Y/self.length)**2 + smoothing)
        self.biasEnergy = numpy.min(self.potential)
        self.potential -= self.biasEnergy

problems = [box,
            space,
            harmonic,
            harmonicWall,
            wall,
            harmonicSingleSlit,
            singleSlit,
            harmonicDoubleSlit,
            doubleSlit,
            hydrogenAtom,
            hydrogenMolecularIon,
            lattice]

for problem in problems:
    run = problem("../QBoxSolver", "./temp/" + problem.__name__)
    run.run()
