#!/usr/bin/env python3

import numpy
import baseRun

wallWidth = 30
wallHeight = 50

class box(baseRun.baseRun):
    def initalize(self):
        self.length = 10.0
        self.mass = 1.0
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.1, 32)

    def initalizePotential(self):
        self.potential = 0*self.X

class space(baseRun.baseRun):
    def initalize(self):
        self.length = 60.0
        self.mass = 1.0
        self.isPeriodicBoundary = True
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.002, 32)

    def initalizePotential(self):
        self.potential = 0*self.X

class harmonic(baseRun.baseRun):
    def initalize(self):
        self.length = 10.0
        self.mass = 1.0
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(1.4, 32)

    def initalizePotential(self):
        self.potential = (self.X**2 + self.Y**2)

class harmonicWall(baseRun.baseRun):
    def initalize(self):
        self.length = 10.0
        self.mass = 1.0
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.1, 32)

    def initalizePotential(self):
        self.potential = (self.X**2 + self.Y**2)
        self.potential[self.resolution//2 - self.resolution//wallWidth:self.resolution//2 + self.resolution//wallWidth, :] += wallHeight

class wall(baseRun.baseRun):
    def initalize(self):
        self.length = 10.0
        self.mass = 1.0
        self.isPeriodicBoundary = True
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.1, 32)

    def initalizePotential(self):
        self.potential = 0*self.X
        self.potential[self.resolution//2 - self.resolution//wallWidth:self.resolution//2 + self.resolution//wallWidth, :] += wallHeight

class harmonicSingleSlit(baseRun.baseRun):
    def initalize(self):
        self.length = 10.0
        self.mass = 1.0
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.5, 32)

    def initalizePotential(self):
        self.potential = (self.X**2 + self.Y**2)
        self.potential[self.resolution//2 - self.resolution//wallWidth:self.resolution//2 + self.resolution//wallWidth, :self.resolution//2 - self.resolution//30] += wallHeight
        self.potential[self.resolution//2 - self.resolution//wallWidth:self.resolution//2 + self.resolution//wallWidth, self.resolution//2 + self.resolution//30:] += wallHeight

class singleSlit(baseRun.baseRun):
    def initalize(self):
        self.length = 10.0
        self.mass = 1.0
        self.isPeriodicBoundary = True
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.2, 32)

    def initalizePotential(self):
        self.potential = 0*self.X
        self.potential[self.resolution//2 - self.resolution//wallWidth:self.resolution//2 + self.resolution//wallWidth, :self.resolution//2 - self.resolution//30] += wallHeight
        self.potential[self.resolution//2 - self.resolution//wallWidth:self.resolution//2 + self.resolution//wallWidth, self.resolution//2 + self.resolution//30:] += wallHeight

class harmonicDoubleSlit(baseRun.baseRun):
    def initalize(self):
        self.length = 10.0
        self.mass = 1.0
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.5, 64)

    def initalizePotential(self):
        self.potential = (self.X**2 + self.Y**2)
        self.potential[self.resolution//2 - self.resolution//wallWidth:self.resolution//2 + self.resolution//wallWidth, :self.resolution//2 - 3*self.resolution//30] += wallHeight
        self.potential[self.resolution//2 - self.resolution//wallWidth:self.resolution//2 + self.resolution//wallWidth, self.resolution//2 - self.resolution//30:self.resolution//2 + self.resolution//30] += wallHeight
        self.potential[self.resolution//2 - self.resolution//wallWidth:self.resolution//2 + self.resolution//wallWidth, self.resolution//2 + 3*self.resolution//30:] += wallHeight

class doubleSlit(baseRun.baseRun):
    def initalize(self):
        self.length = 10.0
        self.mass = 1.0
        self.isPeriodicBoundary = True
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.2, 32)

    def initalizePotential(self):
        self.potential = 0*self.X
        self.potential[self.resolution//2 - self.resolution//wallWidth:self.resolution//2 + self.resolution//wallWidth, :self.resolution//2 - 3*self.resolution//30] += wallHeight
        self.potential[self.resolution//2 - self.resolution//wallWidth:self.resolution//2 + self.resolution//wallWidth, self.resolution//2 - self.resolution//30:self.resolution//2 + self.resolution//30] += wallHeight
        self.potential[self.resolution//2 - self.resolution//wallWidth:self.resolution//2 + self.resolution//wallWidth, self.resolution//2 + 3*self.resolution//30:] += wallHeight

class hydrogenAtom(baseRun.baseRun):
    def initalize(self):
        self.length = 100.0
        self.mass = 1.0
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.01, 32)

    def initalizePotential(self):
        self.potential = 0*self.X
        self.potential = - 1/numpy.sqrt(self.X**2 + self.Y**2)
        self.biasEnergy = numpy.min(self.potential)
        self.potential -= self.biasEnergy

class hydrogenMolecularIon(baseRun.baseRun):
    def initalize(self):
        self.length = 25.0
        self.mass = 1.0
        self.isPeriodicBoundary = False
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.01, 32)

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
        self.length = 10.0
        self.mass = 1.0
        self.isPeriodicBoundary = True
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.01, 32)

    def initalizePotential(self):
        n = 5
        sharp = 64
        depth = 25
        self.potential = -depth*(numpy.cos(n*numpy.pi*self.X/self.length)*numpy.cos(n*numpy.pi*self.Y/self.length))**sharp

class lattice2(baseRun.baseRun):
    def initalize(self):
        self.length = 60.0
        self.mass = 1.0
        self.isPeriodicBoundary = True
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.001, 32)

    def initalizePotential(self):
        n = 15
        sharp = 64
        depth = 8
        self.potential = -depth*(numpy.cos(n*numpy.pi*self.X/self.length)*numpy.cos(n*numpy.pi*self.Y/self.length))**sharp

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
            lattice,
            lattice2]

for problem in problems:
    run = problem("../QBoxSolver", "./temp/" + problem.__name__)
    run.run()
