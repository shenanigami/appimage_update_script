include jansson/Makefile

PWD=$(shell pwd)
SUBDIRS_LIBC += $(PWD)/jansson
OBJDIR := objdir

LIBC_FILES = $(foreach obj, $(OBJS), $(patsubst %.o,$(SUBDIRS_LIBC)/%.c,$(obj)))
C_DEFINES_LIB = -DHAVE_CONFIG_H
FINAL_LIB_OBJS := $(foreach obj, $(OBJS), $(addprefix $(OBJDIR)/,$(obj)))
LD_LIB += jansson
LIB_FILE = libjansson.so

CFILES := process_appimage_request.c
EXTRA_LFLAGS := -Wl,-rpath=$(PWD)
OUTPUT_BINARY := process_appimage_request

$(OBJDIR):
	mkdir $(OBJDIR)

$(FINAL_LIB_OBJS): $(LIBC_FILES) | $(OBJDIR)
	gcc  -c -Wall -fPIC $(C_DEFINES_LIB) -I$(SUBDIRS_LIBC)  $(LIBC_FILES)
	mv ./$(OBJS) $(OBJDIR)/

$(LIB_FILE): $(FINAL_LIB_OBJS)
	gcc -shared -o $@ $(FINAL_LIB_OBJS)

$(OUTPUT_BINARY): $(CFILES) $(LIB_FILE)
	gcc $(CFILES) -L . -l$(LD_LIB) -o $(OUTPUT_BINARY) $(EXTRA_LFLAGS)

.PHONY: print clean
print: ; $(info $$SUBDIRS_LIBC is [gcc  -c -Wall -fPIC ${C_DEFINES_LIB} -I${SUBDIRS_LIBC}  ${LIBC_FILES}])

clean:
	rm -f $(LIB_FILE) $(OUTPUT_BINARY)
	rm -rf $(OBJDIR)
