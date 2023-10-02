# QBoxSolver

Solve the partial in a box problem in Fortran. All equations and units
should be expressed in Hartree units.

# Build
Note these build instructions are a work in progress

sudo apt install build-essential gfortran g++ gcc cmake zlib1g-dev pkg-config
pip3 install h5py

get hdf5 from "https://www.hdfgroup.org/downloads/hdf5/"

            $ gunzip < hdf5-X.Y.Z.tar.gz | tar xf -
            $ mkdir build
            $ cd build
            $ ../hdf5-X.Y.Z/configure --prefix=/usr/local/hdf5 --enable-fortran --enable-shared --enable-static --enable-optimization=high
            $ make
            $ make check                # run test suite.
            $ make install
            $ make check-install        # verify installation.


when attempting to use the .zip version of hdf5-1.14.1-2 the ./config command failed with a mention about being out of date moving to the .tar.gz version fixed the problem.

Alternatively consider using sudo apt install libhdf5-dev hdf5-helpers
