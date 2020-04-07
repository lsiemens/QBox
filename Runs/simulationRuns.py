#!/usr/bin/env python3

import sys
sys.path.insert(0, "../QBoxSolver")
import QBHD

import numpy
from pathlib import Path

from matplotlib import pyplot

resolution = 512
numberOfGrids = 5
maxNumberOfStates = 1024

length = 20.0 # hartree length units
mass = 1 # hartree mass units
omega = 1
wallHeight = 50 # hartree energy units
wallThick = 0.075 # percentage of simulation
wallThin = 0.01 # percentage of simulation
slitWidth = 0.10 # percentage of simulation
isPeriodicPotential = False

def setup(path="./", fname="data.h5", resolution=128, length=10.0):
    Path(path).mkdir(parents=True, exist_ok=True)
    fname = path + "/" + fname
    run = QBHD.create(fname, resolution, length)

    run.numberOfGrids = numberOfGrids
    run.maxNumberOfStates = maxNumberOfStates
    run.mass = mass
    run.biasEnergy = 0.0
    return run

def box(path):
    run = setup(path, resolution=resolution, length=length)

    run.isPeriodicBoundary = False
    run.targetEvolutionTime = run.evolutionTimeCalculator(0.002, 32)
    potential = 0*run.X
    run.potential = potential
    run.save()

def space(path):
    run = setup(path, resolution=resolution, length=length)

    run.isPeriodicBoundary = True
    run.targetEvolutionTime = run.evolutionTimeCalculator(0.002, 32)
    potential = 0*run.X
    run.potential = potential
    run.save()

def harmonic(path):
    run = setup(path, resolution=resolution, length=length)

    run.isPeriodicBoundary = False
    run.targetEvolutionTime = run.evolutionTimeCalculator(0.02, 32)
    potential = (1/2)*run.mass*omega**2*(run.X**2 + run.Y**2)
    run.potential = potential
    run.save()

def harmonicWall(path):
    run = setup(path, resolution=resolution, length=length)

    run.isPeriodicBoundary = False
    run.targetEvolutionTime = run.evolutionTimeCalculator(0.02, 32)
    potential = (1/2)*run.mass*omega**2*(run.X**2 + run.Y**2)
    potential[run.resolution//2 - int(numpy.ceil(run.resolution*wallThin/2)):run.resolution//2 + int(numpy.ceil(run.resolution*wallThin/2)), :] += wallHeight
    run.potential = potential
    run.save()

def wall(path):
    run = setup(path, resolution=resolution, length=length)

    run.isPeriodicBoundary = isPeriodicPotential
    run.targetEvolutionTime = run.evolutionTimeCalculator(0.004, 32)
    potential = 0*run.X
    potential[run.resolution//2 - int(numpy.ceil(run.resolution*wallThin/2)):run.resolution//2 + int(numpy.ceil(run.resolution*wallThin/2)), :] += wallHeight
    run.potential = potential
    run.save()

def harmonicSingleSlit(path):
    run = setup(path, resolution=resolution, length=length)

    run.isPeriodicBoundary = False
    run.targetEvolutionTime = run.evolutionTimeCalculator(0.02, 32)
    potential = (1/2)*run.mass*omega**2*(run.X**2 + run.Y**2)
    potential[run.resolution//2 - int(numpy.ceil(run.resolution*wallThick//2)):run.resolution//2 + int(numpy.ceil(run.resolution*wallThick/2)), :run.resolution//2 - int(numpy.ceil(run.resolution*slitWidth//2))] += wallHeight
    potential[run.resolution//2 - int(numpy.ceil(run.resolution*wallThick//2)):run.resolution//2 + int(numpy.ceil(run.resolution*wallThick/2)), run.resolution//2 + int(numpy.ceil(run.resolution*slitWidth//2)):] += wallHeight
    run.potential = potential
    run.save()

def singleSlit(path):
    run = setup(path, resolution=resolution, length=length)

    run.isPeriodicBoundary = isPeriodicPotential
    run.targetEvolutionTime = run.evolutionTimeCalculator(0.01, 32)
    potential = 0*run.X
    potential[run.resolution//2 - int(numpy.ceil(run.resolution*wallThick//2)):run.resolution//2 + int(numpy.ceil(run.resolution*wallThick/2)), :run.resolution//2 - int(numpy.ceil(run.resolution*slitWidth//2))] += wallHeight
    potential[run.resolution//2 - int(numpy.ceil(run.resolution*wallThick//2)):run.resolution//2 + int(numpy.ceil(run.resolution*wallThick/2)), run.resolution//2 + int(numpy.ceil(run.resolution*slitWidth//2)):] += wallHeight
    run.potential = potential
    run.save()

def harmonicDoubleSlit(path):
    run = setup(path, resolution=resolution, length=length)

    run.isPeriodicBoundary = False
    run.targetEvolutionTime = run.evolutionTimeCalculator(0.02, 32)
    potential = (1/2)*run.mass*omega**2*(run.X**2 + run.Y**2)
    potential[run.resolution//2 - int(numpy.ceil(run.resolution*wallThick/2)):run.resolution//2 + int(numpy.ceil(run.resolution*wallThick/2)), :run.resolution//2 - 3*int(numpy.ceil(run.resolution*slitWidth/2))] += wallHeight
    potential[run.resolution//2 - int(numpy.ceil(run.resolution*wallThick/2)):run.resolution//2 + int(numpy.ceil(run.resolution*wallThick/2)), run.resolution//2 - int(numpy.ceil(run.resolution*slitWidth/2)):run.resolution//2 + int(numpy.ceil(run.resolution*slitWidth/2))] += wallHeight
    potential[run.resolution//2 - int(numpy.ceil(run.resolution*wallThick/2)):run.resolution//2 + int(numpy.ceil(run.resolution*wallThick/2)), run.resolution//2 + 3*int(numpy.ceil(run.resolution*slitWidth/2)):] += wallHeight
    run.potential = potential
    run.save()

def doubleSlit(path):
    run = setup(path, resolution=resolution, length=length)

    run.isPeriodicBoundary = isPeriodicPotential
    run.targetEvolutionTime = run.evolutionTimeCalculator(0.01, 32)
    potential = 0*run.X
    potential[run.resolution//2 - int(numpy.ceil(run.resolution*wallThick/2)):run.resolution//2 + int(numpy.ceil(run.resolution*wallThick/2)), :run.resolution//2 - 3*int(numpy.ceil(run.resolution*slitWidth/2))] += wallHeight
    potential[run.resolution//2 - int(numpy.ceil(run.resolution*wallThick/2)):run.resolution//2 + int(numpy.ceil(run.resolution*wallThick/2)), run.resolution//2 - int(numpy.ceil(run.resolution*slitWidth/2)):run.resolution//2 + int(numpy.ceil(run.resolution*slitWidth/2))] += wallHeight
    potential[run.resolution//2 - int(numpy.ceil(run.resolution*wallThick/2)):run.resolution//2 + int(numpy.ceil(run.resolution*wallThick/2)), run.resolution//2 + 3*int(numpy.ceil(run.resolution*slitWidth/2)):] += wallHeight
    run.potential = potential
    run.save()

def hydrogenAtom(path):
    run = setup(path, resolution=resolution, length=length)

    run.isPeriodicBoundary = False
    run.targetEvolutionTime = run.evolutionTimeCalculator(0.015, 32)
    potential = 0*run.X
    potential = - 1/numpy.sqrt(run.X**2 + run.Y**2)
    biasEnergy = numpy.min(potential)
    potential -= biasEnergy
    run.biasEnergy = biasEnergy
    run.potential = potential
    run.save()

def hydrogenMolecularIon(path):
    run = setup(path, resolution=resolution, length=100.0)

    run.isPeriodicBoundary = False
    run.targetEvolutionTime = run.evolutionTimeCalculator(0.005, 32)
    bondLength = 0.52
    r1 = numpy.sqrt((run.X - bondLength/2)**2 + run.Y**2)
    r2 = numpy.sqrt((run.X + bondLength/2)**2 + run.Y**2)
    potential = 0*run.X
    potential = - 1/r1 - 1/r2 + 1/bondLength
    run.biasEnergy = numpy.min(potential)
    potential -= run.biasEnergy
    run.potential = potential
    run.save()

def lattice(path):
    run = setup(path, resolution=resolution, length=length)

    run.isPeriodicBoundary = True
    run.targetEvolutionTime = run.evolutionTimeCalculator(0.0025, 32)
    n = 3
    smoothing = 0.2
    potential = -1/numpy.sqrt(numpy.sin(n*numpy.pi*run.X/run.length)**2 + numpy.sin(n*numpy.pi*run.Y/run.length)**2 + smoothing)
    run.biasEnergy = numpy.min(potential)
    potential -= run.biasEnergy
    run.potential = potential
    run.save()

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
    run = problem("./temp/" + problem.__name__)
