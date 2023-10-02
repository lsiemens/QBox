# TODO
Current documentation tasks
- [x] App user guide on the website with links in the app
    - [x] How to use the app: Describe options, modes, tips and tricks
    - [ ] How to understand it: brief intro to the physics and interpretations
- [ ] technical guide of the inner workings on the website.
    - [ ] how the unity front end works
    - [ ] how the FORTRAN/Python backend works

Start with local documentation here then when it is close it can be
copied to the gh-pages branch and modified to work with jekyll

## QBox Road Map ##

### Version 1.*.*: Production ###
#### Unity ####
- [ ] Add an _About_ page in the menu. It should contain name, version, descriptions, author and links
- [ ] Add a resolution selector to the Options menu. It will likely be necessary to disable some potentials at low resolution
- [ ] Add low frame rate dialogue to suggest lowering settings. It should appear at most once per session
- [x] Improve the Options page in the menu
- [ ] Document Unity code
- [ ] Reorganize and simplify Unity code
- [x] Fix quantum data and display in the PC version
- [ ] Fix build instructions for QBoxSolver

#### Web and Documentation ####
- [ ] Make a github-pages website. It should have download links, links to the repository and a description of the mathematical methods
- [ ] A post on lsiemens.com about QBox, and integration with qbox.lsiemens.com
- [ ] A document describing the mathematical methods, physics theory and algorithms in QBox

#### Other ####
- [x] Disable sleep in simulation mode
- [x] rename display mode to real part
- [x] Fix QBoxSolver pipeline

### Version ~ 2.0.0: Near Future ###
- [ ] Momentum space representation of wave functions and wave function evolution
- [ ] Measurements of expected position and momentum ...
- [ ] Better color maps
- [ ] Distribution on more platforms

### Version >> 2.0.0: Far Future ###
- [ ] Add perturbation theory and time dependent Hamiltonian (multiple potentials using projection to switch between)
- [ ] 2 particle wave functions in 1D (Add a symmetry/antisymmetry condition to the solver and analysis tools for multiparticle wave functions)
- [ ] Energy level diagrams to track, photon emission/absorption, forbidden transitions and energy level splitting

- [ ] Add tool for thermal pure quantum state (This can approximate the position space distribution of a canonical ensemble for a quantum system)
