
QBox

This project is split into two different parts, the QBox viewer simulates the time
dependent Schrödinger's equation by reconstructing the initial value problem from
steady state solutions. The second part of the project is a program to precompute
the steady state solutions for a quantum potential.

The QBox viewer portion of the program has the following design goals: display
quantum states, display quantum superpositions, construct superpositions from
state coefficients, construct superpositions to approximate arbitrary functions.
The QBox preprocessing portion of the project should be able to: preform high
resolution simulations of Schrödinger's equation to produce steady state solutions,
precompute measurements of the high resolution steady state solutions, generate
a low resolution representation of the steady states and potential function.

The following should be precomputed: position space wave function, the momentum
space wave function, the state energy level, 1st 2nd and 3rd(?) movements of the
position space and momentum space wave functions. In addition pseudo measurements
that are not physically based but mathematical hacks including, computing alternate
wave functions for the function transitions, approximating measurement using
integration with the detector envelopes similar to the point spread function and
aperture shape effects from astronomy.

The goal is for the QBox viewer to produce natural and intuitive representations
of the following mathematical objects: the wave function, the probability amplitude
(wave function magnitude squared), the potential, the state amplitudes, the state
probabilities, the energy levels, the expected position, the variance of the
position, the expected momentum, a the variance of the momentum, the expected
energy, the variance of expected energy.
