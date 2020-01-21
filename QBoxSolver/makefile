QBoxSolver.out: Multigrid.o QBHD.o Types.o
	h5fc QBoxSolver.F03 Types.o QBHD.o Multigrid.o -o QBoxSolver.out

Multigrid.o: Types.o
	h5fc -c Multigrid.F03 -o Multigrid.o

QBHD.o: Types.o
	h5fc -c QBHD.F03 -o QBHD.o

Types.o:
	h5fc -c Types.F03 -o Types.o

run: QBoxSolver.out
	./QBoxSolver.out

clean:
	rm -f *.out
	rm -f *.o
	rm -f *.mod
	rm -f *.h5

