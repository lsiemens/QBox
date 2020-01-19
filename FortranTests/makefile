main:
	h5fc FTest.f03 -o FTest.out

gfortran:
	gfortran FTest.f03 -I/usr/include/hdf5/serial -L/usr/lib/x86_64-linux-gnu/hdf5/serial -lhdf5_fortran -o FTest.out

FTest.out:
	h5fc FTest.f03 -o FTest.out

run: FTest.out
	./FTest.out
	vitables data.h5

clean:
	rm -f *.out
	rm -f *.o
	rm -f *.mod

