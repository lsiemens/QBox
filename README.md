# QBox
A real-time solver for Schrödinger's equation in 2D, focusing on the
particle in a box problem.

## Motivating Ideas
On the graphical side of the project, the idea is to use an
eigenvalue/eigenstate representation of the quantum mechanical system.
In this way we can avoid solving any differential equations in the
graphical software and instead reconstruct solutions from known
eigenstates. This process can be done entirely as graphics shaders,
allowing the software to run on low power devices.

On the backend side of the project, for a given potential the energy
eigenvalues and eigenstates need to be precomputed. Applying a Wick
rotation to the Schrödinger equation produces a new equation that is
analogous to the diffusion equation with an added source term. The energy
eigenstates can be found from this equation using a Gram-Schmidt
orthonormalization.
