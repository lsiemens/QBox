INCLUDE=-I/usr/include/OpenEXR
LINK=-lIlmImf -lHalf -lImath -lIex -lIlmThread -g
# -fsanitize=address

run: test.out test2.out
	./test.out
	./test2.out

test2.out: QBEXR.o
	g++ -Wall QBEXR.o test2.cpp -o test2.out $(INCLUDE) $(LINK)

test.out: QBEXR.o
	g++ -Wall QBEXR.o test.cpp -o test.out $(INCLUDE) $(LINK)

QBEXR.o:
	g++ -Wall -c QBEXR.cpp -o QBEXR.o $(INCLUDE) $(LINK)

writeEXR.out:
	g++ -Wall writeEXR.cpp -o writeEXR.out $(INCLUDE) $(LINK)

writePotential.out:
	g++ -Wall writePotential.cpp -o writePotential.out $(INCLUDE) $(LINK)

readEXR.out:
	g++ -Wall readEXR.cpp -o readEXR.out $(INCLUDE) $(LINK)

readPotential.out:
	g++ -Wall readPotential.cpp -o readPotential.out $(INCLUDE) $(LINK)

clean:
	rm -f *.out
	rm -f *.o
	rm -f *.exr
