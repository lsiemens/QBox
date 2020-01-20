main: TEST.out
	echo ""

gfortran:
	gfortran FTest.F03 -I/usr/include/hdf5/serial -L/usr/lib/x86_64-linux-gnu/hdf5/serial -lhdf5_fortran -o FTest.out

QBHD.o:
	h5fc -c QBHD.F03

TEST.out: QBHD.o
	h5fc TEST.F03 QBHD.o -o TEST.out

CTest.out: QBHD.o
	h5fc CTest.F03 QBHD.o -o CTest.out

data.h5: CTest.out
	./CTest.out

view: data.h5
	vitables data.h5

run: TEST.out data.h5
	./TEST.out
	python3 readData.py

clean:
	rm -f *.out
	rm -f *.o
	rm -f *.mod
	rm -f *.h5

