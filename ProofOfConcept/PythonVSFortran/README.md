# PythonVSFortran

A test to see the speed difrence between Python3 (using NumPy) and Fortran when solving the particle in a box problem. I wrote a python program to reproduce the type of calculations used in the POC code and then implemented the same program in Fortran and compaired the runtime of the two programs. 

result Fortran ran 3~4 times faster. Fortran runtimes appeared to scale linearly with res^2
while python scaled nonlinearly (3 times slower at res=1000 and 4 times slower at res=4000)

I sugest writing the precompute code in fortran.
