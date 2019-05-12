TARGET = mrbtris.elf

OBJS = mrbtris.o romdisk.o game.o

MRB_BYTECODE = game.c

KOS_ROMDISK_DIR = romdisk

CFLAGS = -I/vagrant/src/mruby-sh4/include/ -L/vagrant/src/mruby-sh4/build/host/lib/

all: rm-elf $(TARGET)

include $(KOS_BASE)/Makefile.rules

clean:
	-rm -f $(TARGET) $(OBJS) romdisk.* $(MRB_BYTECODE)

rm-elf:
	-rm -f $(TARGET) romdisk.*

$(TARGET): $(OBJS) $(MRB_BYTECODE)
	kos-cc $(CFLAGS) -o $(TARGET) $(OBJS) -lmruby -lmruby_core -lm

$(MRB_BYTECODE): game.rb
	/vagrant/src/mruby-host/bin/mrbc -Bgame game.rb

run: $(TARGET)
	$(KOS_LOADER) $(TARGET)

dist:
	rm -f $(OBJS) romdisk.o romdisk.img
	$(KOS_STRIP) $(TARGET)
