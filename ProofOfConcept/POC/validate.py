#!/usr/bin/env python3

""" 
Usage:
  validate.py ANALYTIC NUMERICAL [options]
  validate.py -h | --help

Comapaire analytic solutions to numerical solutions.

Arguments:
  ANALYTIC      path to POC readable file containing analytic solutions
  NUMERICAL     path to POC readable file containing numerical solutions

Options:
  -v --verbose      explain what is being done
  -h --help         display this help and exit

"""

import docopt
import numpy
import scipy.stats
from matplotlib import pyplot

import QBox

#analytic_path = "validation_analytic_infinite_well_100_1.0.pk"
#numerical_path = "validation_numerical_infinite_well_100_1.0.pk"
analytic_path = "validation_analytic_harmonic_oscillator_100_10.0.pk"
numerical_path = "validation_numerical_harmonic_oscillator_100_10.0.pk"

def validate(analytic_path, numerical_path, verbose=False):
    analytic_solver = QBox.Analytic(1.0, 10, path=analytic_path)
    analytic_solver.load()

    numerical_solver = QBox.QBox(1.0, 10, path=numerical_path)
    numerical_solver.load()

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
    sem_deviation = scipy.stats.sem(data, axis=None)
    median_deviation = numpy.median(data)

    normalization = []
    energy_reldiff = []
    for subspace in analytic_solver._state_subspace:
        energy = []
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

        energy_reldiff += list((numpy.array(energy) - analytic_solver.Energy_levels[subspace[0]])/analytic_solver.Energy_levels[subspace[0]])
        major_comp = sorted([comp for comp in subspace_components if (not numpy.isclose(comp, 0.0))])
        if verbose:
            if len(subspace) != len(major_comp):
                print("Warning subspace dimension missmatch. Extra component with magnitude ", numpy.array(major_comp[:-len(subspace)]))

    mean_energy_reldiff = numpy.mean(energy_reldiff)
    error_energy_reldiff = scipy.stats.sem(energy_reldiff, axis=None)
    normalization_diff = numpy.array(normalization) - 1.0
    mean_normalization_diff = numpy.mean(normalization_diff)
    error_normalization_diff = scipy.stats.sem(normalization_diff, axis=None)

    print("\nComponent wise deviation from Orthonormal")
    print("max:", max_deviation, "mean:", mean_deviation, "error", sem_deviation, "std:", std_deviation, "med:", median_deviation)

    print("\nmean energy relative difference:", mean_energy_reldiff, "error", error_energy_reldiff)
    print("mean normalization difference:", mean_normalization_diff, "error", error_normalization_diff)

if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    analytic_path = arguments["ANALYTIC"]
    numerical_path = arguments["NUMERICAL"]
    verbose = arguments["--verbose"]
    validate(analytic_path, numerical_path, verbose=verbose)
