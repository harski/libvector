
CC = gcc
CFLAGS = -g -std=gnu99 --pedantic -Wall
ifdef DEBUG
CFLAGS += -DDEBUG
endif

LIBNAME = container

VERSION_MA = 0
VERSION_MI = 4

TARGET_A = lib$(LIBNAME).a
TARGET_SO = lib$(LIBNAME).so.$(VERSION_MA).$(VERSION_MI)

OBJS = vector.o
STATIC_OBJS = $(addprefix static/,$(OBJS))
SHARED_OBJS = $(addprefix shared/,$(OBJS))
STATIC_OBJDIR = static/
SHARED_OBJDIR = shared/
PREFIX = /usr/local
INCLUDEDIR = $(PREFIX)/include
LIBDIR = $(PREFIX)/lib

INSTALL = install
MKDIR = mkdir -p

AR = ar
ARFLAGS = -cvq

all: $(TARGET_A) $(TARGET_SO)

$(TARGET_A): $(STATIC_OBJDIR) $(STATIC_OBJS)
	$(AR) $(ARFLAGS) $@ $(STATIC_OBJS)
	
$(TARGET_SO): $(SHARED_OBJDIR) $(SHARED_OBJS)
	$(CC) -shared -Wl,-soname,lib$(LIBNAME).so.$(VERSION_MA) -o $@ $(SHARED_OBJS)

install: $(PREFIX) $(LIBDIR) $(INCLUDEDIR)
	install -m 0755 $(TARGET_SO) $(LIBDIR)
	ln -sf $(LIBDIR)/lib$(LIBNAME).so.$(VERSION_MA) $(LBDIR)/lib$(LIBNAME).so
	ln -sf $(LBIDIR)/$(TARGET_SO) $(LIBDIR)/lib$(LIBNAME).so.$(VERSION_MA)
	install -m 0644 vector.h $(INCLUDEDIR)
	install -m 0644 $(TARGET_A) $(LIBDIR)

$(PREFIX):
	$(MKDIR) $(PREFIX)

$(LIBDIR):
	$(MKDIR) $(LIBDIR)

$(INCLUDEDIR):
	$(MKDIR) $(INCLUDEDIR)

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

