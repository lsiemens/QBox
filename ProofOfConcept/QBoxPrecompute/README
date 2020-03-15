QBoxPrecompute

Use a fortran solver to find steady state solutions to Shrodinger's Equation.

The core is a Fortran solver with a python wraping layer, and a python utility 
to save the data in a form sutable for Unity. The saved data should consit of 
the following: an EXR image of the potential, a set of EXR atlases containing 
the steady states, and a JSON file containing configuration and data (physical 
constants, simulation parameters, information for unpacking the atlases, and 
state energy leves along with the other precomputed mesurements).

Notes about the EXR images:
All EXR data will be incoded in the following way.

 1. 2D arrays (V, States) will be packed one array per Channel (RGBA)
 2. Flatten these (RGBA) arrays using an atlas, if applicable.
 3. Take the exponential of each color channel (exp(R), exp(B), ...)
 4. Optionaly apply the sRGB to linear RGB color conversion for if unity is in (gamma mode)
