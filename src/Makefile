
CC = gcc
CFLAGS = -g -std=gnu99 --pedantic -Wall
ifdef DEBUG
CFLAGS += -DDEBUG
endif

LIBNAME = container
TARGET_A = lib$(LIBNAME).a
TARGET_SO = lib$(LIBNAME).so

OBJS = vector.o
STATIC_OBJS = $(addprefix static/,$(OBJS))
SHARED_OBJS = $(addprefix shared/,$(OBJS))
STATIC_OBJDIR = static/
SHARED_OBJDIR = shared/
PREFIX = /usr/local
INSTALL = install
MKDIR = mkdir -p

AR = ar
ARFLAGS = -cvq

VERSION_MA = 0
VERSION_MI = 1

all: $(TARGET_A) $(TARGET_SO)

lib$(LIBNAME).a: $(STATIC_OBJDIR) $(STATIC_OBJS)
	$(AR) $(ARFLAGS) lib$(LIBNAME).a $(STATIC_OBJS)
	
lib$(LIBNAME).so: $(SHARED_OBJDIR) $(SHARED_OBJS)
	$(CC) -shared -Wl,-soname,lib$(LIBNAME).so.$(TARGET_MA) -o lib$(LIBNAME).so.$(VERSION_MA).$(VERSION_MI) $(SHARED_OBJS)

install: $(PREFIX)
	install -m 0755 lib$(LIBNAME).so.$(VERSION_MA).$(VERSION_MI) $(PREFIX)/lib
	ln -sf $(PREFIX)/lib/$(LIBNAME).so.$(VERSION_MA).$(VERSION_MI) $(PREFIX)/lib/$(LIBNAME).so
	ln -sf $(PREFIX)/lib/$(LIBNAME).so.$(VERSION_MA).$(VERSION_MI) $(PREFIX)/lib/$(LIBNAME).so.$(VERSION_MA)
	install -m 0644 vector.h $(PREFIX)/include
	install -m 0644 lib$(LIBNAME).a $(PREFIX)/lib

$(STATIC_OBJDIR)%.o: %.c %.h
	$(CC) $(CFLAGS) -c $< -o $@

$(SHARED_OBJDIR)%.o: %.c %.h
	$(CC) $(CFLAGS) -fPIC -c $< -o $@

$(STATIC_OBJDIR):
	test -d $(STATIC_OBJDIR) || $(MKDIR) $(STATIC_OBJDIR)

$(SHARED_OBJDIR):
	test -d $(SHARED_OBJDIR) || $(MKDIR) $(SHARED_OBJDIR)

uninstall:
	rm -rf $(PREFIX)/lib/lib$(LIBNAME)*
	rm -rf $(PREFIX)/include/vector.h

clean:
	rm -rf $(SHARED_OBJS) $(STATIC_OBJS)

.PHONY: all clean install

