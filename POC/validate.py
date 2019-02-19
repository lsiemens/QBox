import numpy
from matplotlib import pyplot
import QBox

x_max = 10.0
resolution = 100
num_states = 100
path = "validation"
isBox = False
type = ""

if isBox:
    type = "infinite_well"
else:
    type = "harmonic_oscillator"

analytic_path = "_".join([path, "analytic", type, str(resolution), str(x_max)]) + ".pk"
analytic_solver = QBox.Analytic(x_max, resolution, path=analytic_path, isBox=isBox)
analytic_solver.set_potential(1.0)

numerical_path = "_".join([path, "numerical", type, str(resolution), str(x_max)]) + ".pk"
numerical_solver = QBox.QBox(x_max, resolution, path=numerical_path)
numerical_solver.set_potential(analytic_solver.V)

analytic_solver.find_quantum_state(num_states)

numerical_solver.load()

#for _ in range(num_states):
#    numerical_solver.find_quantum_state(1, error_level=2.0E-3, max_rounds=50)

data = []
for state_i in numerical_solver.States:
    row = []
    for state_j in numerical_solver.States:
        row.append(numpy.sum(QBox.dboundry(state_i)*QBox.dboundry(numpy.conj(state_j)))*numerical_solver.dx**2)
    data.append(row)
data = numpy.array(data) - numpy.identity(len(data))

max_deviation = numpy.abs(data).max()
mean_deviation = numpy.mean(data)
std_deviation = numpy.std(data)
sem_deviation = std_deviation/numpy.sqrt(len(data.ravel()))
median_deviation = numpy.median(data)
print("max:", max_deviation, "mean:", mean_deviation, "sem:", sem_deviation, "std:", std_deviation, "med:", median_deviation)

for subspace in self._state_subspace:
    for i in subspace:
        analytic_state = numerical_solver.States[i]
        # calculate projection in numerical solution
        # test normalization (did the probability change)
        # test energy (is it the same energy)
        # test dimension of subspace (is there lots of mixing betwean numerical subspaces)
