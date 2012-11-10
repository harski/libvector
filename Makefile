# Copyright 2011-2012 Tuomo Hartikainen <hartitu@gmail.com>.
# Licensed under the 2-clause BSD license, see LICENSE.


include config.mk

ifdef DEBUG
CFLAGS += -g -DDEBUG
endif

LIBNAME = vector

TARGET_A = lib$(LIBNAME).a
TARGET_SO = lib$(LIBNAME).so.$(VERSION_MA).$(VERSION_MI)

HEADER = vector.h
SRCDIR = src
STATIC_OBJDIR = static
SHARED_OBJDIR = shared
INCLUDEDIR = $(PREFIX)/include
LIBDIR = $(PREFIX)/lib

SRC_FILES =$(wildcard $(SRCDIR)/*.c)

STATIC_OBJS =$(subst $(SRCDIR),$(STATIC_OBJDIR),$(SRC_FILES))
STATIC_OBJS :=$(subst .c,.o,$(STATIC_OBJS))

SHARED_OBJS =$(subst $(SRCDIR),$(SHARED_OBJDIR),$(SRC_FILES))
SHARED_OBJS :=$(subst .c,.o,$(SHARED_OBJS))

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
	ln -sf $(LIBDIR)/lib$(LIBNAME).so.$(VERSION_MA) $(LIBDIR)/lib$(LIBNAME).so
	ln -sf $(LIBDIR)/$(TARGET_SO) $(LIBDIR)/lib$(LIBNAME).so.$(VERSION_MA)
	install -m 0644 $(SRCDIR)/$(HEADER) $(INCLUDEDIR)
	install -m 0644 $(TARGET_A) $(LIBDIR)

$(PREFIX):
	$(MKDIR) $(PREFIX)

$(LIBDIR):
	$(MKDIR) $(LIBDIR)

$(INCLUDEDIR):
	$(MKDIR) $(INCLUDEDIR)

$(STATIC_OBJDIR)/%.o: $(SRCDIR)/%.c $(SRCDIR)/%.h
	$(CC) $(CFLAGS) -c $< -o $@

$(SHARED_OBJDIR)/%.o: $(SRCDIR)/%.c $(SRCDIR)/%.h
	$(CC) $(CFLAGS) -fPIC -c $< -o $@

$(STATIC_OBJDIR):
	test -d $(STATIC_OBJDIR) || $(MKDIR) $(STATIC_OBJDIR)

$(SHARED_OBJDIR):
	test -d $(SHARED_OBJDIR) || $(MKDIR) $(SHARED_OBJDIR)

uninstall:
	rm -rf $(PREFIX)/lib/lib$(LIBNAME)*
	rm -rf $(PREFIX)/include/$(HEADER)

clean:
	rm -rf $(SHARED_OBJDIR) $(STATIC_OBJDIR)

.PHONY: all clean install uninstall

