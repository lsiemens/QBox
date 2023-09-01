INCLUDE=-I/usr/include/OpenEXR
LINK=-lIlmImf -lHalf

run: makeEXR.out
	./makeEXR.out

makeEXR.out:
	g++ -Wall makeEXR.cpp -o makeEXR.out $(INCLUDE) $(LINK)

clean:
	rm -f *.out
	rm -f *.o
	rm -f *.exr
