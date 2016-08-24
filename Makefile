EXTRA_WARNINGS := -Wextra -ansi -std=c99 -Wno-unused-parameter

DEPS_LIBS := $(shell pkg-config --libs webkit2gtk-3.0)
DEPS_CFLAGS := $(shell pkg-config --cflags webkit2gtk-3.0)
LDFLAGS := "-I /usr/include/gtk-3.0"
CFLAGS := -ggdb -Wall $(EXTRA_WARNINGS)

all:

yt-player: ytplayer.o resources.o
yt-player: CFLAGS := $(CFLAGS) $(DEPS_CFLAGS)
yt-player: LIBS := $(LIBS) $(DEPS_LIBS)
binaries += yt-player

all: $(binaries)

$(binaries):
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)
	strip $(binaries)
	rm *.o resources.c
%.o:: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

resfiles = $(shell glib-compile-resources --generate-dependencies resources.xml)
resources.c: resources.xml $(resfiles)
	glib-compile-resources --target=$@ --generate-source $<

