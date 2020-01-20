main:
	h5fc FTest.F03 -o FTest.out

gfortran:
	gfortran FTest.F03 -I/usr/include/hdf5/serial -L/usr/lib/x86_64-linux-gnu/hdf5/serial -lhdf5_fortran -o FTest.out

FTest.out:
	h5fc FTest.F03 -o FTest.out

CTest.out:
	h5fc CTest.F03 -o CTest.out

data.h5: CTest.out
	./CTest.out

view: data.h5
	vitables data.h5

run: FTest.out data.h5
	./FTest.out
	python3 readData.py

clean:
	rm -f *.out
	rm -f *.o
	rm -f *.mod
	rm -f *.h5

