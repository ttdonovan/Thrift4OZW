#
# Makefile for Thrift4OZW
# Elias Karakoulakis <elias.karakoulakis@gmail.com>
# based on Makefile for OpenWave Control Panel application by Greg Satz

# GNU make only

.SUFFIXES:	.cpp .o .a .s .thrift

CC     := gcc
CXX    := g++
LD     := g++
AR     := ar rc
RANLIB := ranlib

DEBUG_CFLAGS    := -Wall -Wno-format -g -DDEBUG -Werror -O0
RELEASE_CFLAGS  := -Wall -Wno-unknown-pragmas -Wno-format -O3 -DNDEBUG

DEBUG_LDFLAGS	:= -g

# change directories if needed
OPENZWAVE := ../open-zwave
THRIFT := /usr/local/include/thrift
SMC := /opt/smc

# Change for DEBUG or RELEASE
CFLAGS	:= -c $(DEBUG_CFLAGS) -DDEBUG_POCOSTOMP
LDFLAGS	:= $(DEBUG_LDFLAGS) -L/usr/lib/ -L/usr/local/lib -L/usr/local/lib/thrift -Wl,-rpath=$(OPENZWAVE)/cpp/lib/linux/

INCLUDES := -I $(OPENZWAVE)/cpp/src -I $(OPENZWAVE)/cpp/src/command_classes/ \
	-I $(OPENZWAVE)/cpp/src/value_classes/ -I $(OPENZWAVE)/cpp/src/platform/ \
	-I $(OPENZWAVE)/cpp/src/platform/unix -I $(OPENZWAVE)/cpp/tinyxml/ \
    -I $(THRIFT) -I $(SMC)/lib/C++/ \
	-I . -I gen-cpp/

# Remove comment below for gnutls support
GNUTLS := -lgnutls

LIBZWAVE_STATIC := $(OPENZWAVE)/cpp/lib/linux/libopenzwave.a
LIBZWAVE_DYNAMIC := $(OPENZWAVE)/cpp/lib/linux/libopenzwave.so
LIBUSB := -ludev

# Poco libs are dynamic only (FIXME: phase out Poco!)
LIBPOCO := -lPocoNet -lPocoFoundation 

LIBBOOST := -lboost_thread -lboost_program_options -lboost_filesystem -lboost_system

LIBTHRIFT := -lthrift


# for Mac OS X comment out above 2 lines and uncomment next 2 lines
#LIBZWAVE := $(wildcard $(OPENZWAVE)/cpp/lib/mac/*.a)
#LIBUSB := -framework IOKit -framework CoreFoundation

LIBS := $(GNUTLS) $(LIBUSB) $(LIBPOCO) $(LIBBOOST) $(LIBTHRIFT)


%.o : %.cpp
	$(CXX) $(CFLAGS) $(INCLUDES) -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $<

#all: openzwave ozwd ozwd.static
all: openzwave ozwd

gen-cpp/RemoteManager_server.cpp: create_server.rb gen-cpp/RemoteManager.cpp
	ruby create_server.rb --ozwroot=${OPENZWAVE} --thriftroot=$(THRIFT)
	cp gen-cpp/RemoteManager_server.cpp gen-cpp/RemoteManager_server.cpp.orig
	cp gen-cpp/ozw_types.h gen-cpp/ozw_types.h.orig
	patch -p0 gen-cpp/RemoteManager_server.cpp < gen-cpp/RemoteManager_server.cpp.patch
	patch -p0 gen-cpp/ozw_types.h <gen-cpp/ozw_types.h.patch
    
gen-cpp/RemoteManager.cpp: ozw.thrift
	thrift --gen cocoa --gen cpp --gen csharp --gen erl --gen go --gen java --gen js --gen perl --gen php --gen py --gen rb ozw.thrift

gen-cpp/RemoteManager.o: gen-cpp/RemoteManager.cpp
	g++ $(CFLAGS) -c gen-cpp/RemoteManager.cpp -o gen-cpp/RemoteManager.o $(INCLUDES)

gen-cpp/ozw_constants.o:  gen-cpp/ozw_constants.cpp
	g++ $(CFLAGS) -c gen-cpp/ozw_constants.cpp -o gen-cpp/ozw_constants.o $(INCLUDES)
    
gen-cpp/ozw_types.o:  gen-cpp/ozw_types.cpp gen-cpp/ozw_types.h
	g++ $(CFLAGS) -c gen-cpp/ozw_types.cpp -o gen-cpp/ozw_types.o $(INCLUDES)
    
Stomp_sm.cpp: Stomp.sm
	smc -c++ Stomp.sm 

Stomp_sm.o: Stomp_sm.cpp 
	g++ $(CFLAGS) -c Stomp_sm.cpp $(INCLUDES)
    
StompSocket.o: StompSocket.cpp StompSocket.h
	g++ $(CFLAGS) -c StompSocket.cpp $(INCLUDES)
    
PocoStomp.o:  PocoStomp.cpp PocoStomp.h Stomp_sm.cpp StompSocket.o
	g++ $(CFLAGS) -c PocoStomp.cpp $(INCLUDES)    

Main.o: Main.cpp Stomp_sm.o gen-cpp/RemoteManager_server.cpp
	g++ $(CFLAGS) -c Main.cpp $(INCLUDES)   

openzwave: $(LIBZWAVE_STATIC) $(LIBZWAVE_DYNAMIC)
	cd $(OPENZWAVE)/cpp/build/linux/; make
	
#
# until we can get Poco out of the way, there's no static build yet
#
#ozwd.static: Main.o  Stomp_sm.o StompSocket.o PocoStomp.o gen-cpp/RemoteManager.o gen-cpp/ozw_constants.o gen-cpp/ozw_types.o $(LIBZWAVE_STATIC)
#	$(LD) -static -static-libgcc -o $@ $(LDFLAGS) Main.o Stomp_sm.o StompSocket.o PocoStomp.o gen-cpp/RemoteManager.o gen-cpp/ozw_constants.o gen-cpp/ozw_types.o $(LIBS) $(LIBZWAVE_STATIC)

ozwd:   Main.o  Stomp_sm.o StompSocket.o PocoStomp.o gen-cpp/RemoteManager.o gen-cpp/ozw_constants.o gen-cpp/ozw_types.o $(LIBZWAVE_DYNAMIC) 
	$(LD) -o $@ $(LDFLAGS) Main.o Stomp_sm.o StompSocket.o PocoStomp.o gen-cpp/RemoteManager.o gen-cpp/ozw_constants.o gen-cpp/ozw_types.o $(LIBS) $(LIBZWAVE_DYNAMIC)	 

dist:	main
	rm -f Thrift4OZW.tar.gz
	tar -c --exclude=".git" --exclude ".svn" --exclude "*.o" -hvzf Thrift4OZW.tar.gz *.cpp *.h *.thrift *.sm *.rb Makefile gen-*/ license/ README*

bindist: main
	rm -f Thrift4OZW_bin_`uname -i`.tar.gz
	upx ozwd*
	tar -c --exclude=".git" --exclude ".svn" -hvzf Thrift4OZW_bin_`uname -i`.tar.gz ozwd license/ README*

clean:
	rm -f ozwd*.o Stomp_sm.* gen-cpp/RemoteManager.cpp gen-cpp/RemoteManager_server.cpp gen-cpp/ozw_types.h

binclean: 
	rm -f ozwd *.o  gen-cpp/*.o
    
thrift: gen-cpp/RemoteManager.cpp

patchdiffs:
	- diff -C3 gen-cpp/ozw_types.h.orig gen-cpp/ozw_types.h.patched > gen-cpp/ozw_types.h.patch
	- diff -C3 gen-cpp/RemoteManager_server.cpp.orig gen-cpp/RemoteManager_server.cpp.patched > gen-cpp/RemoteManager_server.cpp.patch
