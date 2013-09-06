CPPFLAGS += -lncurses -lstdc++
LDFLAGS += -lncurses -lstdc++

all : launch

*.o : launch.cpp uvm_boat_anchor.cpp

launch : launch.o uvm_boat_anchor.o

clean :
	rm -rf launch *.o run.log sim.log work
