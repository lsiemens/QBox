import numpy

res, iterations = 100, 10000
dt = 0.1
V = 0*numpy.empty((res, res))
phi = (1.0 + 1.0j) + 0*V
a = (0.0 + 0.0j) + 0*V
grad = (0.0 + 0.0j) + 0*V

phi[0, :] = (0.0 + 0.0j)
phi[res - 1, :] = (0.0 + 0.0j)
phi[:, 0] = (0.0 + 0.0j)
phi[:, res - 1] = (0.0 + 0.0j)

phi = phi/numpy.sqrt(numpy.sum(numpy.conj(phi)*phi))

for i in range(iterations):
    phi = phi - numpy.sum(numpy.conj(a)*phi)*a
    grad[1:-1, 1:-1] = phi[2:, 1:-1] + phi[:-2, 1:-1] + phi[1:-1, 2:] + phi[1:-1, :-2] - 4*phi[1:-1, 1:-1]
    phi = phi + dt*(grad - V*phi)
    phi = phi/numpy.sqrt(numpy.sum(numpy.conj(phi)*phi))
