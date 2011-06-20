dnl confFlu - pythonFlu configuration package
dnl Copyright (C) 2010- Alexey Petrov
dnl Copyright (C) 2009-2010 Pebble Bed Modular Reactor (Pty) Limited (PBMR)
dnl 
dnl This program is free software: you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation, either version 3 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl 
dnl You should have received a copy of the GNU General Public License
dnl along with this program.  If not, see <http://www.gnu.org/licenses/>.
dnl 
dnl See http://sourceforge.net/projects/pythonflu
dnl
dnl Author : Alexey PETROV
dnl


dnl --------------------------------------------------------------------------------
AC_DEFUN([CONFFLU_CHECK_LOKI],dnl
[
AC_CHECKING(for Loki Library)

AC_LANG_SAVE
AC_LANG_CPLUSPLUS

LOKI_CPPFLAGS=""
AC_SUBST(LOKI_CPPFLAGS)

LOKI_CXXFLAGS="-DLOKI_OBJECT_LEVEL_THREADING"
AC_SUBST(LOKI_CXXFLAGS)

LOKI_LDFLAGS=""
AC_SUBST(LOKI_LDFLAGS)

LOKI_LIBS="-lloki"
AC_SUBST(LOKI_LIBS)

loki_ok=no

dnl --------------------------------------------------------------------------------
loki_includes_ok=no
AC_ARG_WITH( [loki_includes],
             AC_HELP_STRING( [--with-loki-includes=<path>],
                             [use <path> to look for Loki includes] ),
             [],
             [ with_loki_includes=no ] )
   
dnl AC_MSG_NOTICE( \${with_loki_includes} ${with_loki_includes})

if test "x${loki_includes_ok}" = "xno" && test ! "x${LOKI_ROOT_DIR}" = "x" ; then
   with_loki_includes="${LOKI_ROOT_DIR}/include"
   AC_CHECK_FILE( [${with_loki_includes}/loki/Threads.h], [ loki_includes_ok=yes ], [ loki_includes_ok=no ] )
fi

if test "x${loki_includes_ok}" = "xno" ; then
   with_loki_includes="/usr/include"
   AC_CHECK_FILE( [${with_loki_includes}/loki/Threads.h], [ loki_includes_ok=yes ], [ loki_includes_ok=no ] )
fi

if test "x${loki_includes_ok}" = "xyes" ; then
   test ! "x${with_loki_includes}" = "x/usr/include" && LOKI_CPPFLAGS="-I${with_loki_includes}"
   CPPFLAGS="${LOKI_CPPFLAGS}"

   AC_CHECK_HEADERS( [loki/Threads.h], [ loki_includes_ok=yes ], [ loki_includes_ok=no ] )
fi

if test "x${loki_includes_ok}" = "xno" ; then
   AC_MSG_WARN( [use --with-loki-includes=<path> to define Loki header files location] )
fi

dnl --------------------------------------------------------------------------------
loki_libraries_ok=no
AC_ARG_WITH( [loki_libraries],
             AC_HELP_STRING( [--with-loki-libraries=<path>],
                             [use <path> to look for Loki libraries] ),
             [],
             [ with_loki_libraries=no ]  )
   
if test "x${with_loki_libraries}" = "xno" && test ! "x${LOKI_ROOT_DIR}" = "x" ; then
   with_loki_libraries=${LOKI_ROOT_DIR}/lib
   AC_CHECK_FILE( [${with_loki_libraries}/libloki.so], [ loki_libraries_ok=yes ], [ loki_libraries_ok=no ] )
fi

if test "x${vtk_libraries_ok}" = "xno" ; then
   with_loki_libraries="/usr/lib"
   AC_CHECK_FILE( [${with_loki_libraries}/libloki.so], [ loki_libraries_ok=yes ], [ loki_libraries_ok=no ] )
fi

if test "x${loki_libraries_ok}" = "xyes" ; then
   CXXFLAGS="${LOKI_CXXFLAGS}"

   test ! "x${with_loki_libraries}" = "x/usr/lib" && LOKI_LDFLAGS="-L${with_loki_libraries}"
   LDFLAGS="${LOKI_LDFLAGS}"
   LIBS="${LOKI_LIBS}"

   AC_MSG_CHECKING( for Loki functionality )
   AC_LINK_IFELSE( [ AC_LANG_PROGRAM( [ #include <loki/Threads.h> ], 
                                      [ Loki::ObjectLevelLockable< int > TParent ] ) ],
                   [ loki_libraries_ok=yes ],
                   [ loki_libraries_ok=no ] )
   AC_MSG_RESULT( ${loki_libraries_ok} )
fi

if test "x${loki_libraries_ok}" = "xno" ; then
   AC_MSG_WARN( [use --with-loki-libraries=<path> to define Loki libraries location] )
fi

dnl --------------------------------------------------------------------------------
if test "x${loki_includes_ok}" = "xyes" && test "x${loki_libraries_ok}" = "xyes" ; then
   loki_ok="yes"
fi

AC_LANG_RESTORE
])


dnl --------------------------------------------------------------------------------
