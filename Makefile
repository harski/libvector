# Copyright 2011-2012 Tuomo Hartikainen <hartitu@gmail.com>.
# Licensed under the 2-clause BSD license, see LICENSE.


include config.mk

ifdef DEBUG
CFLAGS += -g -DDEBUG
endif

LIBNAME = vector

VERSION_MA = 0
VERSION_MI = 6

TARGET_A = lib$(LIBNAME).a
TARGET_SO = lib$(LIBNAME).so.$(VERSION_MA).$(VERSION_MI)

HEADER = vector.h
SRCDIR = src
STATIC_OBJDIR = static
SHARED_OBJDIR = shared
INCLUDEDIR = $(PREFIX)/include
LIBDIR = $(PREFIX)/lib
PC_FILE = lib$(LIBNAME).pc
PC_DIR = $(PREFIX)/lib/pkgconfig

SRC_FILES =$(wildcard $(SRCDIR)/*.c)

STATIC_OBJS =$(subst $(SRCDIR),$(STATIC_OBJDIR),$(SRC_FILES))
STATIC_OBJS :=$(subst .c,.o,$(STATIC_OBJS))

SHARED_OBJS =$(subst $(SRCDIR),$(SHARED_OBJDIR),$(SRC_FILES))
SHARED_OBJS :=$(subst .c,.o,$(SHARED_OBJS))

INSTALL = install
MKDIR = mkdir -p

AR = ar
ARFLAGS = -cvq

all: $(TARGET_A) $(TARGET_SO) $(PC_FILE)

$(TARGET_A): $(STATIC_OBJDIR) $(STATIC_OBJS)
	$(AR) $(ARFLAGS) $@ $(STATIC_OBJS)

$(TARGET_SO): $(SHARED_OBJDIR) $(SHARED_OBJS)
	$(CC) -shared -Wl,-soname,lib$(LIBNAME).so.$(VERSION_MA) -o $@ $(SHARED_OBJS)

install: $(PREFIX) $(LIBDIR) $(INCLUDEDIR) $(PC_DIR)
	install -m 0755 $(TARGET_SO) $(LIBDIR)
	ln -sf $(LIBDIR)/lib$(LIBNAME).so.$(VERSION_MA) $(LIBDIR)/lib$(LIBNAME).so
	ln -sf $(LIBDIR)/$(TARGET_SO) $(LIBDIR)/lib$(LIBNAME).so.$(VERSION_MA)
	install -m 0644 $(SRCDIR)/$(HEADER) $(INCLUDEDIR)
	install -m 0644 $(TARGET_A) $(LIBDIR)
	install -m 0644 $(PC_FILE) $(PC_DIR)

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

$(PC_DIR):
	test -d $(PC_DIR) || $(MKDIR) $(PC_DIR)

$(PC_FILE):
	@echo "prefix=$(PREFIX)" > $@
	@echo "libdir=\$${prefix}/lib" >> $@
	@echo "includedir=\$${prefix}/include" >> $@
	@echo "" >> $@
	@echo "Name: libvector" >> $@
	@echo "Description: Vector data structure for storing (void *)" >> $@
	@echo "Version: $(VERSION_MA).$(VERSION_MI)" >> $@
	@echo "Libs: -L\$${libdir} -lvector" >> $@
	@echo "Cflags: -I\$${includedir}" >> $@

uninstall:
	rm -rf $(PREFIX)/lib/lib$(LIBNAME)*
	rm -rf $(PREFIX)/include/$(HEADER)

clean:
	rm -rf $(SHARED_OBJDIR) $(STATIC_OBJDIR)
	rm -rf $(TARGET_A) $(TARGET_SO)
	rm -rf $(PC_FILE)

.PHONY: all clean install uninstall

