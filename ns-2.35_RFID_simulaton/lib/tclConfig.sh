# tclConfig.sh --
# 
# This shell script (for sh) is generated automatically by Tcl's
# configure script.  It will create shell variables for most of
# the configuration options discovered by the configure script.
# This script is intended to be included by the configure scripts
# for Tcl extensions so that they don't have to figure this all
# out for themselves.
#
# The information in this file is specific to a single platform.

# Tcl's version number.
TCL_VERSION='8.5'
TCL_MAJOR_VERSION='8'
TCL_MINOR_VERSION='5'
TCL_PATCH_LEVEL='.10'

# C compiler to use for compilation.
TCL_CC='gcc'

# -D flags for use with the C compiler.
TCL_DEFS='-DPACKAGE_NAME=\"tcl\" -DPACKAGE_TARNAME=\"tcl\" -DPACKAGE_VERSION=\"8.5\" -DPACKAGE_STRING=\"tcl\ 8.5\" -DPACKAGE_BUGREPORT=\"\" -DPACKAGE_URL=\"\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_LIMITS_H=1 -DHAVE_SYS_PARAM_H=1 -DTCL_CFGVAL_ENCODING=\"iso8859-1\" -DSTATIC_BUILD=1 -DMODULE_SCOPE=extern\ __attribute__\(\(__visibility__\(\"hidden\"\)\)\) -DTCL_SHLIB_EXT=\".so\" -DTCL_CFG_OPTIMIZED=1 -DTCL_CFG_DEBUG=1 -DTCL_TOMMATH=1 -DMP_PREC=4 -D_LARGEFILE64_SOURCE=1 -DTCL_WIDE_INT_IS_LONG=1 -DHAVE_GETCWD=1 -DHAVE_OPENDIR=1 -DHAVE_STRTOL=1 -DHAVE_WAITPID=1 -DHAVE_GETADDRINFO=1 -DUSE_TERMIOS=1 -DHAVE_SYS_TIME_H=1 -DTIME_WITH_SYS_TIME=1 -DHAVE_GMTIME_R=1 -DHAVE_LOCALTIME_R=1 -DHAVE_MKTIME=1 -DHAVE_TM_GMTOFF=1 -DHAVE_TIMEZONE_VAR=1 -DHAVE_STRUCT_STAT_ST_BLOCKS=1 -DHAVE_STRUCT_STAT_ST_BLKSIZE=1 -DHAVE_BLKCNT_T=1 -DHAVE_INTPTR_T=1 -DHAVE_UINTPTR_T=1 -DHAVE_SIGNED_CHAR=1 -DHAVE_LANGINFO=1 -DHAVE_FTS=1 -DHAVE_SYS_IOCTL_H=1 -DTCL_UNLOAD_DLLS=1'

# TCL_DBGX used to be used to distinguish debug vs. non-debug builds.
# This was a righteous pain so the core doesn't do that any more.
TCL_DBGX=

# Default flags used in an optimized and debuggable build, respectively.
TCL_CFLAGS_DEBUG='-g'
TCL_CFLAGS_OPTIMIZE='-O2'

# Default linker flags used in an optimized and debuggable build, respectively.
TCL_LDFLAGS_DEBUG=''
TCL_LDFLAGS_OPTIMIZE=''

# Flag, 1: we built a shared lib, 0 we didn't
TCL_SHARED_BUILD=0

# The name of the Tcl library (may be either a .a file or a shared library):
TCL_LIB_FILE='libtcl8.5.a'

# Additional libraries to use when linking Tcl.
TCL_LIBS='-ldl  -lieee -lm'

# Top-level directory in which Tcl's platform-independent files are
# installed.
TCL_PREFIX='/home/nobat/ns-allinone-2.35'

# Top-level directory in which Tcl's platform-specific files (e.g.
# executables) are installed.
TCL_EXEC_PREFIX='/home/nobat/ns-allinone-2.35'

# Flags to pass to cc when compiling the components of a shared library:
TCL_SHLIB_CFLAGS='-fPIC'

# Flags to pass to cc to get warning messages
TCL_CFLAGS_WARNING='-Wall'

# Extra flags to pass to cc:
TCL_EXTRA_CFLAGS=' -pipe '

# Base command to use for combining object files into a shared library:
TCL_SHLIB_LD='${CC} -shared ${CFLAGS} ${LDFLAGS}'

# Base command to use for combining object files into a static library:
TCL_STLIB_LD='${AR} cr'

# Either '$LIBS' (if dependent libraries should be included when linking
# shared libraries) or an empty string.  See Tcl's configure.in for more
# explanation.
TCL_SHLIB_LD_LIBS='${LIBS}'

# Suffix to use for the name of a shared library.
TCL_SHLIB_SUFFIX='.so'

# Library file(s) to include in tclsh and other base applications
# in order to provide facilities needed by DLOBJ above.
TCL_DL_LIBS='-ldl'

# Flags to pass to the compiler when linking object files into
# an executable tclsh or tcltest binary.
TCL_LD_FLAGS=' -Wl,--export-dynamic '

# Flags to pass to ld, such as "-R /usr/local/tcl/lib", that tell the
# run-time dynamic linker where to look for shared libraries such as
# libtcl.so.  Used when linking applications.  Only works if there
# is a variable "LIB_RUNTIME_DIR" defined in the Makefile.
TCL_CC_SEARCH_FLAGS='-Wl,-rpath,${LIB_RUNTIME_DIR}'
TCL_LD_SEARCH_FLAGS='-Wl,-rpath,${LIB_RUNTIME_DIR}'

# Additional object files linked with Tcl to provide compatibility
# with standard facilities from ANSI C or POSIX.
TCL_COMPAT_OBJS=''

# Name of the ranlib program to use.
TCL_RANLIB='ranlib'

# -l flag to pass to the linker to pick up the Tcl library
TCL_LIB_FLAG='-ltcl8.5'

# String to pass to linker to pick up the Tcl library from its
# build directory.
TCL_BUILD_LIB_SPEC='-L/home/nobat/ns-allinone-2.35/tcl8.5.10/unix -ltcl8.5'

# String to pass to linker to pick up the Tcl library from its
# installed directory.
TCL_LIB_SPEC='-L/home/nobat/ns-allinone-2.35/lib -ltcl8.5'

# String to pass to the compiler so that an extension can
# find installed Tcl headers.
TCL_INCLUDE_SPEC='-I/home/nobat/ns-allinone-2.35/include'

# Indicates whether a version numbers should be used in -l switches
# ("ok" means it's safe to use switches like -ltcl7.5;  "nodots" means
# use switches like -ltcl75).  SunOS and FreeBSD require "nodots", for
# example.
TCL_LIB_VERSIONS_OK='ok'

# String that can be evaluated to generate the part of a shared library
# name that comes after the "libxxx" (includes version number, if any,
# extension, and anything else needed).  May depend on the variables
# VERSION and SHLIB_SUFFIX.  On most UNIX systems this is
# ${VERSION}${SHLIB_SUFFIX}.
TCL_SHARED_LIB_SUFFIX='${VERSION}.so'

# String that can be evaluated to generate the part of an unshared library
# name that comes after the "libxxx" (includes version number, if any,
# extension, and anything else needed).  May depend on the variable
# VERSION.  On most UNIX systems this is ${VERSION}.a.
TCL_UNSHARED_LIB_SUFFIX='${VERSION}.a'

# Location of the top-level source directory from which Tcl was built.
# This is the directory that contains a README file as well as
# subdirectories such as generic, unix, etc.  If Tcl was compiled in a
# different place than the directory containing the source files, this
# points to the location of the sources, not the location where Tcl was
# compiled.
TCL_SRC_DIR='/home/nobat/ns-allinone-2.35/tcl8.5.10'

# List of standard directories in which to look for packages during
# "package require" commands.  Contains the "prefix" directory plus also
# the "exec_prefix" directory, if it is different.
TCL_PACKAGE_PATH='/home/nobat/ns-allinone-2.35/lib '

# Tcl supports stub.
TCL_SUPPORTS_STUBS=1

# The name of the Tcl stub library (.a):
TCL_STUB_LIB_FILE='libtclstub8.5.a'

# -l flag to pass to the linker to pick up the Tcl stub library
TCL_STUB_LIB_FLAG='-ltclstub8.5'

# String to pass to linker to pick up the Tcl stub library from its
# build directory.
TCL_BUILD_STUB_LIB_SPEC='-L/home/nobat/ns-allinone-2.35/tcl8.5.10/unix -ltclstub8.5'

# String to pass to linker to pick up the Tcl stub library from its
# installed directory.
TCL_STUB_LIB_SPEC='-L/home/nobat/ns-allinone-2.35/lib -ltclstub8.5'

# Path to the Tcl stub library in the build directory.
TCL_BUILD_STUB_LIB_PATH='/home/nobat/ns-allinone-2.35/tcl8.5.10/unix/libtclstub8.5.a'

# Path to the Tcl stub library in the install directory.
TCL_STUB_LIB_PATH='/home/nobat/ns-allinone-2.35/lib/libtclstub8.5.a'

# Flag, 1: we built Tcl with threads enables, 0 we didn't
TCL_THREADS=0
