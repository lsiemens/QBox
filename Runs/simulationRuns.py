import numpy
import baseRun

wallWidth = 30
wallHeight = 10

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
        self.length = 10.0
        self.mass = 1.0
        self.isPeriodicBoundary = True
        self.targetEvolutionTime = self.evolutionTimeCalculator(0.2, 32)

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

run = harmonicDoubleSlit("../../QBoxSolver/QBoxSolver.out")
run.run()
