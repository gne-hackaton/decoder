PROJECTNAME=decoder
SDKVER=5.0
SDK=/Developer_ios5/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator$(SDKVER).sdk

CC=/Developer_ios5/Platforms/iPhoneSimulator.platform/Developer/usr/bin/clang
Cpp=/Developer_ios5/Platforms/iPhoneSimulator.platform/Developer/usr/bin/i686-apple-darwin10-g++-4.2.1

#CC=/Developer/Platforms/iPhoneOS.platform/usr/bin/llvm-gcc-4.2 
#Cpp=/Developer/Platforms/iPhoneOS.platform/usr/bin/llvm-g++-4.2 
LD=$(CC)

LDFLAGS += -framework CoreFoundation
LDFLAGS += -framework Foundation
LDFLAGS += -framework UIKit
LDFLAGS += -framework CoreGraphics
LDFLAGS += -framework AddressBookUI
LDFLAGS += -framework AddressBook
LDFLAGS += -framework QuartzCore
# LDFLAGS += -framework GraphicsServices
# LDFLAGS += -framework CoreSurface
# LDFLAGS += -framework CoreAudio
# LDFLAGS += -framework Celestial
# LDFLAGS += -framework AudioToolbox
# LDFLAGS += -framework WebCore
# LDFLAGS += -framework WebKit
# LDFLAGS += -framework SystemConfiguration
# LDFLAGS += -framework CFNetwork
# LDFLAGS += -framework MediaPlayer
# LDFLAGS += -framework OpenGLES
# LDFLAGS += -framework OpenAL

LDFLAGS += -L"$(SDK)/usr/lib"
LDFLAGS += -F"$(SDK)/System/Library/Frameworks"
LDFLAGS += -F"$(SDK)/System/Library/PrivateFrameworks"

#for sqllite
LDFLAGS += -l"sqlite3.0"

CFLAGS += -I"/Developer_ios5/Platforms/iPhoneSimulator.platform/Developer/usr/clang-ide/lib/clang/3.0/include"
CFLAGS += -I"$(SDK)/usr/include"
CFLAGS += -I"/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/include/"
CFLAGS += -I"/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator$(SDKVER).sdk/usr/include"
CFLAGS += -DDEBUG -std=c99
CFLAGS += -miphoneos-version-min=3.0
CFLAGS += -F"$(SDK)/System/Library/Frameworks"
CFLAGS += -F"$(SDK)/System/Library/PrivateFrameworks"


# find all directories within the project that have .m or .h files in it, exclude Three20
VPATH := $(shell find . -iregex ".*/three20.*/.*" -prune -o \( -iname "*.h" -or -iname "*.m" \) -exec dirname {} \; | sort | uniq)

# add them to the list of searched directories for header files
CFLAGS += $(patsubst %,-iquote"%",$(VPATH))

#special entry for Three20 because they require a slightly different path
#and are commonly used

# THREE20_PATH += $(shell find . \( -regex ".*/Build/.*/three20/.*" -and -iname "Three20.h" \) -exec dirname {} \; | xargs -n 1 dirname |sort | uniq)

# VPATH += $THREE20_PATH
# # add three20 to the list of searched directories for header files
# CFLAGS += $(patsubst %,-I"%",$(THREE20_PATH))

CFLAGS += -include ./gRide_Prefix.pch

CPPFLAGS=$CFLAGS

BUILDDIR=./build/$(SDKVER)
SRCDIR=./Classes
RESDIR=./Resources

# list of *.c and *.m files in the project, without the directory name
OBJ_FILES := $(shell find . \( -iname "*.c" -or -iname "*.m" \) -exec basename {} \; | sort | uniq)
OBJ_FILES := $(patsubst %.m,%.o,$(OBJ_FILES))
OBJ_FILES := $(patsubst %.c,%.o,$(OBJ_FILES))
OBJS=$(OBJ_FILES)

RESOURCES=$(wildcard $(RESDIR)/*)
RESOURCES+=$(wildcard ./*.png)

all: $(PROJECTNAME)

$(PROJECTNAME): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.m
	$(CC) -c $(CFLAGS) $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

.PHONY: check-syntax
check-syntax:
	$(CC) $(CFLAGS) -Wall -Wextra -fsyntax-only $(CHK_SOURCES)


