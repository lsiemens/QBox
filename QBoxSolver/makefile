QBoxSolver.out: Multigrid.o Math.o QBHDBackEnd.o QBHD.o Types.o
	h5fc QBoxSolver.F90 Types.o QBHD.o QBHDBackEnd.o Math.o Multigrid.o -o QBoxSolver.out

Multigrid.o: Math.o Types.o
	h5fc -c Multigrid.F90 -o Multigrid.o

Math.o: Types.o
	h5fc -c Math.F90 -o Math.o

QBHDBackEnd.o: QBHD.o
	h5fc -c QBHDBackEnd.F90 -o QBHDBackEnd.o

QBHD.o: Types.o
	h5fc -c QBHD.F90 -o QBHD.o

Types.o:
	h5fc -c Types.F90 -o Types.o

run: QBoxSolver.out data.h5
	./QBoxSolver.out
	python3 readData.py

view: data.h5
	python3 readData.py

clean:
	rm -f *.out
	rm -f *.o
	rm -f *.mod
	rm -f *.smod
	rm -f *.h5
	rm -f stop.msg

data.h5:
	python3 runSetup.py
