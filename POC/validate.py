import numpy
from matplotlib import pyplot
import QBox

x_max = 1.0
resolution = 100
num_states = 100
path = "validation"
isBox = True
type = ""

"validation_numerical_infinite_well_100_1.0.pk"

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

for subspace in analytic_solver._state_subspace:
    print("sub space", subspace)
    energy = []
    normalization = []
    vector_components = []
    for i in subspace:
        analytic_state = analytic_solver.States[i]
        phi_state = numerical_solver.calculate_constants(analytic_state)
        phi = numerical_solver.system(phi_state, 0)

        energy_method_coefficient = 0.0
        phi_contribution = []
        for i, coefficient in phi_state:
            phi_contribution.append((i, coefficient*numpy.conj(coefficient)))
            energy_method_coefficient += coefficient*numerical_solver.Energy_levels[i]*numpy.conj(coefficient)

        norm = numpy.sum([prob for _, prob in phi_contribution])

        energy_method_expectation, _ = numerical_solver.get_energy_new(phi)
        energy_method_ratio, _ = numerical_solver.get_energy(phi)

        normalization.append(norm)
        energy += [energy_method_expectation, energy_method_ratio, energy_method_coefficient]
        vector_components += phi_contribution

    subspace_components = numpy.zeros(shape=(len(analytic_solver.States),))
    for component in vector_components:
        i, prob = component
        subspace_components[i] += prob

    print(normalization)
    print(energy)
    print([comp for comp in subspace_components if (not numpy.isclose(comp, 0.0))])
    print()

    # calculate projection in numerical solution
    # O test normalization (did the probability change)
    # O test energy (is it the same energy)
    # O test dimension of subspace (is there lots of mixing betwean numerical subspaces)
