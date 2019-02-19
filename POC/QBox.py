### Proof Of Concept

# Equations:
#   i*h_bar*(d/dt)phi = (-h_bar^2/(2*mass))*(d^2/dx^2)phi + V*phi

#   t' = -t*i
#   -h_bar*(d/dt')phi = (-h_bar^2/(2*mass))*(d^2/dx^2)phi + V*phi

#   (d/dt')phi = (h_bar/(2*mass))*(d^2/dx^2)phi - V*phi/h_bar

import time
import pickle
import array

from scipy.special import factorial
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

def dboundry(phi, n=2):
    return phi[n:-n,n:-n]

class QBox:
    def __init__(self, x_max, res, path="DATA_QBox.pk"):
        self.h_bar = 1.0
        self.mass = 1.0
        self.x_max = x_max
        self.res = res
        self.path = path

        self.x = numpy.linspace(-x_max, x_max, res)
        self.y = numpy.linspace(-x_max, x_max, res)
        self.dx = numpy.mean(self.x[1:] - self.x[:-1])
        self.X, self.Y = numpy.meshgrid(self.x, self.y)

        self.min_resolved_phi = numpy.sqrt(1.0/(2*self.x_max)**2) # sqrt of uniform probability density

        self.V = 0*self.X
        self.States = []
        self.Energy_levels = []

    def bsave(self, file, verbose=False): # save incomplete data in binary form
        id = 2020557393
        num = len(self.States)
        n = self.res
        byte_len = 4*3 + 4*(n**2 + 1)*num

        if (verbose):
            print("writing " + str(byte_len) + " bytes to file: " + file)
        with open(file, "wb") as fout:
            if (verbose):
                print("\tfile type ID: " + str(id) + "\n\tnumber of energy eigenfunctions: " + str(num) + "\n\tresolution: " + str(n) + "x" + str(n))
            bdata = array.array("I", [id, num, n])
            bdata.tofile(fout)

            for state in self.States:
                bdata = array.array("f", list(state.ravel()))
                bdata.tofile(fout)

            bdata = array.array("f", self.Energy_levels)
            bdata.tofile(fout)

    def save(self):
        with open(self.path, "wb") as fout:
            data_phys = {"h_bar":self.h_bar, "mass":self.mass}
            data_grid = {"x":self.x, "y":self.y, "X":self.X, "Y":self.Y, "dx":self.dx}
            data_quantum = {"States":self.States, "Energy_levels":self.Energy_levels, "V":self.V}
            DATA = {"data_phys":data_phys, "data_grid":data_grid, "data_quantum":data_quantum}
            pickle.dump(DATA, fout)

    def load(self, verbose=False):
        with open(self.path, "rb") as fin:
            if verbose:
                print("loading POC pickle file: " + self.path)
            DATA = pickle.load(fin)
            data_phys = DATA["data_phys"]
            data_grid = DATA["data_grid"]
            data_quantum = DATA["data_quantum"]

            self.h_bar, self.mass = data_phys["h_bar"], data_phys["mass"]
            self.x, self.y, self.X, self.Y, self.dx = data_grid["x"], data_grid["y"], data_grid["X"], data_grid["Y"], data_grid["dx"]
            self.States, self.Energy_levels, self.V = data_quantum["States"], data_quantum["Energy_levels"], data_quantum["V"]

            self.res = len(self.x)
            self.x_max = self.x[-1]
            self.min_resolved_phi = numpy.sqrt(1.0/(2*self.x_max)**2) # sqrt of uniform probability density

    def set_potential(self, V):
        self.V = V

    def find_quantum_state(self, num_states, error_level=2.0E-5, max_rounds=50):
        for i in range(num_states):
            dt = 0.1
            r_max, r_min = 0.4, 0.1
            swaps_max = 10
            swaps = 0
            phi = self.normalize(numpy.random.uniform(-1.0, 1.0, size=self.X.shape))

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
                        phi = phi - numpy.sum(phi*numpy.conj(state))*self.dx**2*state
                    F = (numpy.roll(phi, 1, axis=0) + numpy.roll(phi, -1, axis=0) + numpy.roll(phi, 1, axis=1) + numpy.roll(phi, -1, axis=1) - 4*phi)/self.dx**2
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

                    phi = self.normalize(phi + dt_phi*dt)
                phi = self.normalize(phi)
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

    def get_energy_new(self, phi, perr=False):
        E_hat = self.E_hat
        E = self.expectation_value(phi, operator=E_hat)
        Esqr_hat = lambda phi : self.E_hat(self.E_hat(phi))
        E_error = numpy.sqrt(numpy.abs(self.expectation_value(phi, Esqr_hat) - E**2))
#        print(E_error/numpy.sqrt(len(phi.ravel())))
        return E, E_error

    def E_hat(self, phi):
        F = (numpy.roll(phi, 1, axis=0) + numpy.roll(phi, -1, axis=0) + numpy.roll(phi, 1, axis=1) + numpy.roll(phi, -1, axis=1) - 4*phi)/self.dx**2
        return (((-self.h_bar**2/(2*self.mass))*F) + self.V*phi)

    def get_energy(self, phi, perr=False):
        phi = numpy.array(phi)
        E_local = self.E_hat(phi)
# -------------------------------- Do I still need this --------------------------------------------
#        phi[numpy.abs(phi)<self.min_resolved_phi] = numpy.nan
        E_local = dboundry(E_local/phi)
#        E_local[E_local < 0] = numpy.nan #----------------------------- Does this help
        if perr:
            pyplot.hist(E_local[~numpy.isnan(E_local)].ravel(), 100)
            pyplot.show()
        E, E_error = numpy.nanmean(E_local), numpy.nanstd(E_local)
#        print(E_error/numpy.sqrt(numpy.count_nonzero(~numpy.isnan(E_local))))
        return E, E_error

    def expectation_value(self, phi, operator=None):
#        if operator is None:
#            return numpy.sum(phi*numpy.conj(phi))*self.dx**2
#        else:
#            return numpy.sum(phi*operator(numpy.conj(phi)))*self.dx**2

# ---------------------------------------- Energy is Biased as low resolution -----------------------------
        if operator is None:
            return numpy.sum(dboundry(phi)*dboundry(numpy.conj(phi)))*self.dx**2
        else:
            return numpy.sum(dboundry(phi)*dboundry(operator(numpy.conj(phi))))*self.dx**2

    def normalize(self, phi):
        return phi/numpy.sqrt(self.expectation_value(phi))

    def normalize_constants(self, pairs):
        for state_id, _ in pairs:
            if (state_id < 0) or (state_id >= len(self.States)):
                raise ValueError("invalid state id")

        sqrt_mag = numpy.sqrt(numpy.sum([numpy.abs(alpha)**2 for _, alpha in pairs]))
        return [(state_id, alpha/sqrt_mag) for state_id, alpha in pairs]

    def calculate_constants(self, function):
        function = normalize(function)
        pairs = []
        for i, state in enumerate(self.States):
            pair = (i, numpy.sum(function*numpy.conj(state))*self.dx**2)
            pairs.append(pair)
        return pairs

    def system(self, A, t):
        phi = (0.0 + 0.0j)*self.X
        for state_id, alpha in A:
            phi += alpha*self.States[state_id]*numpy.exp((-1.0j*self.Energy_levels[state_id]/self.h_bar)*t)
        return phi

class Analytic(QBox):
    def __init__(self, x_max, res, path, isBox=True):
        super().__init__(x_max, res, path)
        self.isBox = isBox;
        self._indices = []
        self.omega = 1
        self._hermite_polynomial_comp = {}
        if not self.isBox:
            self.set_potential(self.omega)

    def set_potential(self, omega):
        self.omega = omega
        if not self.isBox:
            self.V = self.mass*self.omega**2*(self.X**2 + self.Y**2)/2.0
        else:
            self.V = self.X*0

    def find_quantum_state(self, num_states, error_level=None, max_rounds=None):
        if self.isBox:
            self.find_quantum_state_box(len(self.States) + num_states)
        else:
            self.find_quantum_state_oscillator(len(self.States) + num_states)

    def find_quantum_state_box(self, num_states):
        indices = []
        n = int(numpy.sqrt(numpy.sqrt(2)*num_states))
        for i in range(1, (n + 1)):
            for j in range(1, (n + 1)):
                indices.append((i**2 + j**2, (i, j)))
        indices.sort(key=lambda tup: tup[0])
        indices=indices[:num_states]

        self._indices = [quantum_numbers for _, quantum_numbers in indices]

        E_0 = (self.h_bar**2*numpy.pi**2*2)/(2*self.mass*(2*self.x_max)**2)
        self.Energy_levels = [E_0*k/2.0 for k, _ in indices]

        for n_x, n_y in self._indices:
            phi = numpy.sin(n_x*numpy.pi*(self.X + self.x_max)/(2*self.x_max))*numpy.sin(n_y*numpy.pi*(self.Y + self.x_max)/(2*self.x_max))/self.x_max
            self.States.append(phi)
        self.save()

    def find_quantum_state_oscillator(self, num_states):
        indices = []
        n = int(numpy.sqrt(1 + 8*num_states)/2) + 1
        for i in range(n):
            for j in range(n):
                indices.append((i + j, (i, j)))
        indices.sort(key=lambda tup: tup[0])
        indices=indices[:num_states]

        self._indices = [quantum_numbers for _, quantum_numbers in indices]

        self.Energy_levels = [self.h_bar*self.omega*(k + 1) for k, _ in indices]

        for n_x, n_y in self._indices:
            # swaping axis to produce _oscillator_1d_y
            phi = self._oscillator_1d_x(n_x)*numpy.swapaxes(self._oscillator_1d_x(n_y), 0, 1)
            self.States.append(phi)
        self.save()

    def _oscillator_1d_x(self, n):
        a = numpy.sqrt(self.mass*self.omega/self.h_bar)
        normalization_constant = numpy.sqrt(a/(2**n*numpy.sqrt(numpy.pi)*factorial(n)))
        phi = numpy.exp(-a**2*self.X**2/2)*self._hermite_polynomial(n, a*self.X)
        return normalization_constant*phi

    def _hermite_polynomial(self, n, X):
        n = int(n)
        if n in self._hermite_polynomial_comp:
            return self._hermite_polynomial_comp[n]

        if (n == 0):
            function = X*0 + 1.0
            self._hermite_polynomial_comp[n] = function
            return function
        elif (n == 1):
            function = 2*X
            self._hermite_polynomial_comp[n] = function
            return function
        else:
            function = 2*X*self._hermite_polynomial(n - 1, X) - 2*(n - 1)*self._hermite_polynomial(n - 2, X)
            self._hermite_polynomial_comp[n] = function
            return function
