# Proof of concept
This directory contains multiple early proof of concepts tests, this
ranged from testing language features to verifying that time dependent
states can be computed in the gpu.

    - PythonVsFortran: Speed testing Python and Fortran for the precomputation of QBox states
    - FortranTests: Test writeing HDF5 files from Fortran and reading them from Python
    - QBoxPrecompute: Save QBox state data in a form sutible for Unity
    - POC: Test finding energy eigenvalues and eigenstates using a Wick rotated
           version of the Schrodinger equation and Gram-Schmidt orthonormalization.
    - GPOC: proof of concept for the graphical systems. Using the gpu to combine
            energy eigenvalues and eigenstates into a time dependent quantum state.
