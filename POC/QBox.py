### Proof Of Concept

# Equations:
#   i*h_bar*(d/dt)phi = (-h_bar^2/(2*mass))*(d^2/dx^2)phi + V*phi

#   t' = -t*i
#   -h_bar*(d/dt')phi = (-h_bar^2/(2*mass))*(d^2/dx^2)phi + V*phi

#   (d/dt')phi = (h_bar/(2*mass))*(d^2/dx^2)phi - V*phi/h_bar

import time
import pickle
import array

import numpy
from matplotlib import pyplot

def plot(phi, all=False):
    if all:
        pyplot.imshow(numpy.real(phi))
        pyplot.show()
        pyplot.imshow(numpy.imag(phi))
        pyplot.show()
    pyplot.imshow(numpy.abs(phi)**2)
    pyplot.show()

def boundry(phi):
    phi[:,  0] = 0.0
    phi[:, -1] = 0.0
    phi[0,  :] = 0.0
    phi[-1, :] = 0.0
    return phi

def normalize(phi):
    mag = numpy.sum(numpy.abs(phi)**2)
#    print(mag)
    return phi/numpy.sqrt(mag)

class QBox:
    def __init__(self, x_max, res, path="DATA_QBox.pk"):
        self.h_bar = 1.0
        self.mass = 1.0
        self.x_max = x_max
        self.res = res
        self.path = path

        self.min_resolved_phi = numpy.sqrt(1.0/self.res**2) # sqrt of uniform probability density

        self.x = numpy.linspace(-x_max, x_max, res)
        self.y = numpy.linspace(-x_max, x_max, res)
        self.dx = numpy.mean(self.x[1:] - self.x[:-1])
        self.X, self.Y = numpy.meshgrid(self.x, self.y)

        self.V = 0*self.X
        self.States = []
        self.Energy_levels = []

    def bsave(self, file): # save incomplete data in binary form
        id = 2020557393
        num = len(self.States)
        n = self.res
        byte_len = 4*3 + 4*(n**2 + 1)*num

        print("writing " + str(byte_len) + " bytes.")
        with open(file, "wb") as fout:
            print(id, num, n)
            bdata = array.array("I", [id, num, n])
            bdata.tofile(fout)

            for state in self.States:
                bdata = array.array("f", list(state.ravel()))
                bdata.tofile(fout)

            bdata = array.array("f", self.Energy_levels)
            bdata.tofile(fout)

    def bload(file): # load incomplete data in binary form
        pass

    def save(self):
        with open(self.path, "wb") as fout:
            data_phys = {"h_bar":self.h_bar, "mass":self.mass}
            data_grid = {"x":self.x, "y":self.y, "X":self.X, "Y":self.Y, "dx":self.dx}
            data_quantum = {"States":self.States, "Energy_levels":self.Energy_levels, "V":self.V}
            DATA = {"data_phys":data_phys, "data_grid":data_grid, "data_quantum":data_quantum}
            pickle.dump(DATA, fout)

    def load(self):
        with open(self.path, "rb") as fin:
            DATA = pickle.load(fin)
            data_phys = DATA["data_phys"]
            data_grid = DATA["data_grid"]
            data_quantum = DATA["data_quantum"]

            self.h_bar, self.mass = data_phys["h_bar"], data_phys["mass"]
            self.x, self.y, self.X, self.Y, self.dx = data_grid["x"], data_grid["y"], data_grid["X"], data_grid["Y"], data_grid["dx"]
            self.States, self.Energy_levels, self.V = data_quantum["States"], data_quantum["Energy_levels"], data_quantum["V"]

    def set_potential(self, V):
        self.V = V

    def find_quantum_state(self, num_states, error_level=2.0E-5, max_rounds=50):
        for i in range(num_states):
            dt = 0.1
            r_max, r_min = 0.4, 0.1
            swaps_max = 10
            swaps = 0
            phi = normalize(numpy.random.uniform(-1.0, 1.0, size=self.X.shape))

#############
#            e, error = [], []
#############

            E, E_error = 0, numpy.inf
            num_rounds = 0
            max_round = max_rounds
            while E_error > error_level:
                for _ in range(1000):
                    phi = boundry(phi)
                    for state in self.States:
                        phi = phi - numpy.sum(phi*numpy.conj(state))*state
                    F = numpy.roll(phi, 1, axis=0) + numpy.roll(phi, -1, axis=0) + numpy.roll(phi, 1, axis=1) + numpy.roll(phi, -1, axis=1) - 4*phi
                    dt_phi = (self.h_bar/(2*self.mass)*F) - self.V*phi/self.h_bar

                    a, da = (numpy.abs(phi)).max(), dt*(numpy.abs(dt_phi)).max()
                    if da/a > r_max:
                        dt = dt*0.5
                        swaps += 1
                    elif da/a < r_min:
                        dt = dt*2.0
                        swaps += 1
                    if swaps > swaps_max:
                        swaps = 0
                        r_max = r_max*0.5
                        r_min = r_min*0.5

                    phi = normalize(phi + dt_phi*dt)
                phi = normalize(phi)
                E, E_error = self.get_energy(phi)
                if num_rounds > max_round:
                    print("E_error has not met the minimum requirement before timing out.")
                    break
                num_rounds += 1
                print(num_rounds)

############################
#                print(E_error)
#                e.append(E)
#                error.append(E_error)
#            pyplot.plot(e)
#            pyplot.show()
#            pyplot.plot(error)
#            pyplot.show()
#            self.get_energy(phi, True)
##############################

#            self.States.append(normalize(phi))
            self.States.append(phi)
            print(E, E_error)
            self.Energy_levels.append(E)
        self.save()

    def get_energy(self, phi, perr=False):
        phi = numpy.array(phi)
        F = numpy.roll(phi, 1, axis=0) + numpy.roll(phi, -1, axis=0) + numpy.roll(phi, 1, axis=1) + numpy.roll(phi, -1, axis=1) - 4*phi
        mask = numpy.abs(phi)<self.min_resolved_phi
        phi[numpy.abs(phi)<self.min_resolved_phi] = numpy.nan
        E_local = (-self.h_bar**2/(2*self.mass))*F/phi + self.V
        if perr:
            pyplot.hist(E_local[~mask].ravel(), 100)
            pyplot.show()
        E, E_error = numpy.nanmean(E_local), numpy.nanstd(E_local)
        return E, E_error

    def normalize_constants(self, pairs):
        for state_id, _ in pairs:
            if (state_id < 0) or (state_id >= len(self.States)):
                raise ValueError("invalid state id")

        sqrt_mag = numpy.sqrt(numpy.sum([numpy.abs(alpha)**2 for _, alpha in pairs]))
        return [(state_id, alpha/sqrt_mag) for state_id, alpha in pairs]

    def expectation_value(self, phi, operator=None):
        if operator is None:
            return numpy.sum(phi*numpy.conj(phi))
        else:
            return numpy.sum(phi*operator(numpy.conj(phi)))

    def calculate_constants(self, function):
        function = normalize(function)
        pairs = []
        for i, state in enumerate(self.States):
            pair = (i, numpy.sum(function*numpy.conj(state)))
            pairs.append(pair)
        return pairs

    def system(self, A, t):
        phi = (0.0 + 0.0j)*self.X
        for state_id, alpha in A:
            phi += alpha*self.States[state_id]*numpy.exp((-1.0j*self.Energy_levels[state_id]/self.h_bar)*t)
        return phi
