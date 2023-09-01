INCLUDE=-I/usr/include/OpenEXR
LINK=-lIlmImf -lHalf

run: makeEXR.out readEXR.out
	./makeEXR.out
	./readEXR.out

makeEXR.out:
	g++ -Wall makeEXR.cpp -o makeEXR.out $(INCLUDE) $(LINK)

readEXR.out:
	g++ -Wall readEXR.cpp -o readEXR.out $(INCLUDE) $(LINK)

clean:
	rm -f *.out
	rm -f *.o
	rm -f *.exr
