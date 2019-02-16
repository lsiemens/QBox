ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
FREETYPE_DIR=/usr/include/freetype2

INCLUDE=$(ROOT_DIR)/include
CFLAGS=-g -I$(INCLUDE)
LINKFLAGS=-ldl -lglfw -lfreetype
OBJECTS=glad.o QBox_POC.o state_machine.o

GPOC.out:$(OBJECTS)
	g++ GPOC.cpp $(OBJECTS) $(CFLAGS) $(LINKFLAGS) -o GPOC.out

prun:pclean GPOC.out
	$(bash) ./GPOC.out

crun:clean GPOC.out
	$(bash) ./GPOC.out

run:GPOC.out
	$(bash) ./GPOC.out

glad.o:
	gcc -c $(INCLUDE)/glad/glad.c $(CFLAGS) -o glad.o

QBox_POC.o:
	g++ -c QBox_POC.cpp $(CFLAGS) -o QBox_POC.o

state_machine.o:
	g++ -c state_machine.cpp $(CFLAGS) -o state_machine.o

.PHONY:clean
clean:
	rm -f *.o *.out

.PHONY:pclean
pclean:
	rm -f state_machine.o *.out

