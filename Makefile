OPENRESTY_PREFIX=/opt/openresty

PREFIX ?=          /opt/openresty
LUA_INCLUDE_DIR ?= $(PREFIX)/luajit/include/luajit-2.1
LUA_LIB_DIR ?=     $(PREFIX)/lualib/$(LUA_VERSION)
INSTALL ?= install

CMPFLAG       = -c -fPIC
LINKFLAG      = -shared
.PHONY: all test install clean

all: lib/libredis_slot.so

clean:
	rm -rf lib/*.so lib/*.o

lib/redis_slot.o:lib/redis_slot.c
	$(CC) $(CMPFLAG) -I$(LUA_INCLUDE_DIR) -o $@ $^

lib/libredis_slot.so:lib/redis_slot.o
	$(CC) $(LINKFLAG) -o $@ $^

install: all
	$(INSTALL) -d $(DESTDIR)/$(LUA_LIB_DIR)/resty
	$(INSTALL) lib/resty/*.lua $(DESTDIR)/$(LUA_LIB_DIR)/resty
	$(INSTALL) lib/libredis_slot.so $(DESTDIR)/$(LUA_LIB_DIR)/libredis_slot.so

test: all
	PATH=$(OPENRESTY_PREFIX)/nginx/sbin:$$PATH prove -I../test-nginx/lib -r t

