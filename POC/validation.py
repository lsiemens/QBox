import QBox

x_max = 10.0
resolution = 100
num_states = 100
path = "validation"
isBox = True
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

solver.load()

#analytic_solver.find_quantum_state(num_states)

#for _ in range(num_states):
#    numerical_solver.find_quantum_state(1, error_level=2.0E-3, max_rounds=50)

for state in numerical_solver.States:
    QBox.plot(state)




