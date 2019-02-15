ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
FREETYPE_DIR=/usr/include/freetype2

INCLUDE=$(ROOT_DIR)/include
CFLAGS=-g -I$(INCLUDE)
LINKFLAGS=-ldl -lglfw -lfreetype
OBJECTS=glad.o stb_image.o shader.o texture.o resource_manager.o text_renderer.o \
        sprite_renderer.o state_machine.o

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

stb_image.o:
	g++ -c $(INCLUDE)/stb_image/stb_image.cpp -o stb_image.o

shader.o:
	g++ -c shader.cpp $(CFLAGS) -o shader.o

texture.o:
	g++ -c texture.cpp $(CFLAGS) -o texture.o

resource_manager.o:
	g++ -c resource_manager.cpp $(CFLAGS) -o resource_manager.o

text_renderer.o:
	g++ -c text_renderer.cpp $(CFLAGS) -I$(FREETYPE_DIR) -o text_renderer.o

sprite_renderer.o:
	g++ -c sprite_renderer.cpp $(CFLAGS) -o sprite_renderer.o

state_machine.o:
	g++ -c state_machine.cpp $(CFLAGS) -o state_machine.o

.PHONY:clean
clean:
	rm -f *.o *.out

.PHONY:pclean
pclean:
	rm -f state_machine.o *.out

