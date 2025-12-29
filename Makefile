FB = 1
X11 = 0
WAYLAND = 0

CC=cc
SRC = src/view.c src/magic.c src/book.c src/db.c
SRC += $(wildcard src/book-*.c)
LIBS = -lxxhash -lmupdf -lmagic -lm -ldjvulibre -lspectre
CFLAGS += -g

ifeq ($(FB),1)
    SRC += src/graphics-fb.c
    CFLAGS += -DVIEW_FB
endif
ifeq ($(X11),1)
    SRC += src/graphics-x11.c
    LIBS += -lX11
    CFLAGS += -DVIEW_X11
endif
ifeq ($(WAYLAND),1)
    SRC += src/graphics-wayland.c
    SRC += gen/xdg-shell.c
    LIBS += -lwayland-client -lxkbcommon
    CFLAGS += -DVIEW_WAY
endif

all: view

view: $(SRC)
	$(CC) $(CFLAGS) $^ -o $@ $(LIBS) -I/usr/include/freetype2 -Ilibs

gen/xdg-shell.c:
	mkdir gen
	wayland-scanner private-code  < /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml > gen/xdg-shell.c
	wayland-scanner client-header < /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml > gen/xdg-shell.h
