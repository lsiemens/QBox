DEST="."

run: QBoxSolver.out
	./QBoxSolver.out
	python3 ../../QBoxSolver/readData.py

view:
	python3 ../../QBoxSolver/readData.py

QBoxSolver.out:
	python3 ../simulationRuns.py

clean:
	rm -f *.h5
	rm -f *.out
	rm -f stop.msg
