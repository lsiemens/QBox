INCLUDE=-I/usr/include/OpenEXR
LINK=-lIlmImf -lHalf -lImath -lIex -lIlmThread

run: writePotential.out readPotential.out
	./writePotential.out
	./readPotential.out

makeEXR.out:
	g++ -Wall makeEXR.cpp -o makeEXR.out $(INCLUDE) $(LINK)

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
