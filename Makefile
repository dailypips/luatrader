include skynet/platform.mk
.PHONY: all skynet clean

LUA_CLIB_PATH ?= luaclib

CFLAGS = -g -O2 -Wall -I$(LUA_INC) $(MYCFLAGS)

# lua
LUA_STATICLIB := skynet/3rd/lua/liblua.a
LUA_INC ?= skynet/3rd/lua

# zlog
ZLOG_STATICLIB := zlog/zlog_pic.a
ZLOG_INC := zlog/src

all : zlog
.PHONY : zlog

$(ZLOG_STATICLIB) : zlog/makefile
    cd zlog && $(MAKE) CC=$(CC)

LUA_CLIB = log

all : skynet

skynet/Makefile :
	git submodule update --init

skynet : skynet/Makefile
	cd skynet && $(MAKE) $(PLAT) && cd ..

all : \
  $(foreach v, $(LUA_CLIB), $(LUA_CLIB_PATH)/$(v).so)

$(LUA_CLIB_PATH) :
	mkdir $(LUA_CLIB_PATH)


$(LUA_CLIB_PATH)/log.so : lualib-src/lua-log.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@

clean :
	cd skynet && $(MAKE) clean
	
