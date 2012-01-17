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
AC_DEFUN([CONFFLU_CHECK_BOOST],
[
AC_CHECKING(for Boost Library in general)
AC_REQUIRE([CONFFLU_CHECK_OS])
AC_REQUIRE([CONFFLU_CHECK_PYTHON])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS
STORE_CPPFLAGS=${CPPFLAGS}
STORE_CXXFLAGS=${CXXFLAGS}
STORE_LDFLAGS=${LDFLAGS}

BOOST_CPPFLAGS=""
AC_SUBST(BOOST_CPPFLAGS)

BOOST_CXXFLAGS=""
AC_SUBST(BOOST_CXXFLAGS)

BOOST_LDFLAGS=""
AC_SUBST(BOOST_LDFLAGS)

BOOST_LIBSUFFIX="-mt"
AC_SUBST(BOOST_LIBSUFFIX)

boost_ok=no

dnl --------------------------------------------------------------------------------
dnl Check for Boost includes
boost_includes_ok=no
AC_ARG_WITH( [boost_includes],
             AC_HELP_STRING( [--with-boost-includes=<path>],
                             [use <path> to look for BOOST includes] ),
             [],
             [] )
   
dnl First checking command line options
if test ! "x${with_boost_includes}" = "x"; then
   AC_CHECK_FILE( [${with_boost_includes}/boost/version.hpp], [ boost_includes_ok=yes ], [ boost_includes_ok=no ] )
fi

dnl Second try to use SALOME environment  
if test "x${boost_includes_ok}" = "xno" && test ! "x${BOOSTDIR}" = "x" ; then
   with_boost_includes="${BOOSTDIR}/include"
   AC_CHECK_FILE( [${with_boost_includes}/boost/version.hpp], [ boost_includes_ok=yes ], [ boost_includes_ok=no ] )
fi

dnl Try to use native environment
if test "x${boost_includes_ok}" = "xno" ; then
   with_boost_includes="/usr/include"
   AC_CHECK_FILE( [${with_boost_includes}/boost/version.hpp], [ boost_includes_ok=yes ], [ boost_includes_ok=no ] )
fi

dnl Try to use the MacPorts-installation on Macs
if test "x${boost_includes_ok}" = "xno" ; then
   with_boost_includes="/opt/local/include"
   AC_CHECK_FILE( [${with_boost_includes}/boost/version.hpp], [ boost_includes_ok=yes ], [ boost_includes_ok=no ] )
fi

dnl Define corresponding common preprocessor & compiler flags
if test "x${boost_includes_ok}" = "xyes" ; then
   test ! "x${with_boost_includes}" = "x/usr/include" && BOOST_CPPFLAGS="-I${with_boost_includes}"
   CPPFLAGS="${BOOST_CPPFLAGS}"

   BOOST_CXXFLAGS="-ftemplate-depth-40"
   CXXFLAGS="${BOOST_CXXFLAGS}"

   AC_CHECK_HEADERS( [boost/version.hpp], [ boost_includes_ok=yes ], [ boost_includes_ok=no ] )
fi

if test "x${boost_includes_ok}" = "xno" ; then
   AC_MSG_WARN( [use --with-boost-includes=<path> to define BOOST header files location] )
fi


dnl --------------------------------------------------------------------------------
dnl Check for Boost libraries
boost_libraries_ok=no
AC_ARG_WITH( [boost_libraries],
             AC_HELP_STRING( [--with-boost-libraries=<path>],
                             [use <path> to look for BOOST libraries] ),
             [],
             []  )


dnl First checking command line options   
if test ! "x${with_boost_libraries}" = "x" ; then
   a_boost_lib=`ls ${with_boost_libraries} | grep -E "^libboost_.*\${LIB_EXTENSION}$" | tail --lines=1`
   if test ! "x${a_boost_lib}" = "x" ; then
      AC_CHECK_FILE( [${with_boost_libraries}/${a_boost_lib}], [ boost_libraries_ok=yes ], [ boost_libraries_ok=no ] )
   fi
fi

dnl Second try to use SALOME environment   
if test "x${boost_libraries_ok}" = "xno" && test ! "x${BOOSTDIR}" = "x" ; then
   with_boost_libraries="${BOOSTDIR}/lib"
   a_boost_lib=`ls ${with_boost_libraries} | grep -E "^libboost_.*\${LIB_EXTENSION}$" | tail --lines=1`
   if test ! "x${a_boost_lib}" = "x" ; then
      AC_CHECK_FILE( [${with_boost_libraries}/${a_boost_lib}], [ boost_libraries_ok=yes ], [ boost_libraries_ok=no ] )
   fi
fi

dnl Try to use native environment
if test "x${boost_libraries_ok}" = "xno" ; then
   with_boost_libraries="/usr/lib"
   a_boost_lib=`ls ${with_boost_libraries} | grep -E "^libboost_.*\${LIB_EXTENSION}$" | tail --lines=1`
   if test ! "x${a_boost_lib}" = "x" ; then
      AC_CHECK_FILE( [${with_boost_libraries}/${a_boost_lib}], [ boost_libraries_ok=yes ], [ boost_libraries_ok=no ] )
   fi
fi

dnl Try to use the MacPorts-installation on Macs
if test "x${boost_libraries_ok}" = "xno" ; then
   with_boost_libraries="/opt/local/lib"
   a_boost_lib=`ls ${with_boost_libraries} | grep -E "^libboost_.*\${LIB_EXTENSION}$" | tail --lines=1`
   if test ! "x${a_boost_lib}" = "x" ; then
      AC_CHECK_FILE( [${with_boost_libraries}/${a_boost_lib}], [ boost_libraries_ok=yes ], [ boost_libraries_ok=no ] )
   fi
fi

dnl Define corresponding common linker flags
if test "x${boost_libraries_ok}" = "xyes" ; then
   test ! "x${with_boost_libraries}" = "x/usr/lib" && BOOST_LDFLAGS="-L${with_boost_libraries}"
   LDFLAGS="${BOOST_LDFLAGS}"
   
   a_boost_lib=`ls ${with_boost_libraries} | grep -E "^libboost_.*-mt\.\${LIB_EXTENSION}$" | tail --lines=1`

   if test "x${a_boost_lib}" = "x" ; then
      a_boost_lib=`ls ${with_boost_libraries} | grep -E "^libboost_.*\.\${LIB_EXTENSION}$" | tail --lines=1`
   fi
   BOOST_LIBSUFFIX=[`echo ${a_boost_lib} | sed -e "s%libboost_[a-z]*%%g" | sed -e "s%\.\${LIB_EXTENSION}%%g"`]
fi

if test "x${boost_libraries_ok}" = "xyes" ; then
   AC_CHECK_FILE( [${with_boost_libraries}/${a_boost_lib}], [ boost_libraries_ok=yes ], [ boost_libraries_ok=no ] )
   AC_MSG_NOTICE( @BOOST_LIBSUFFIX@ == "${BOOST_LIBSUFFIX}" )
fi

if test "x${boost_libraries_ok}" = "xno" ; then
   AC_MSG_WARN( [use --with-boost-libraries=<path> to define BOOST libraries location] )
fi

dnl --------------------------------------------------------------------------------
if test "x${boost_includes_ok}" = "xyes" && test "x${boost_libraries_ok}" = "xyes" ; then
   boost_ok="yes"
fi

BOOST_VERSION=[`cat ${with_boost_includes}/boost/version.hpp  | grep "\#define BOOST_VERSION " | sed -e "s/\#define BOOST_VERSION //g"`]
AC_MSG_NOTICE( @BOOST_VERSION@ == "${BOOST_VERSION}" )

BOOST_MAJOR_VERSION=[`python -c "print ${BOOST_VERSION} / 100000"`]
AC_MSG_NOTICE( @BOOST_MAJOR_VERSION@ == "${BOOST_MAJOR_VERSION}" )

BOOST_MINOR_VERSION=[`python -c "print ${BOOST_VERSION} / 100 % 1000"`]
AC_MSG_NOTICE( @BOOST_MINOR_VERSION@ == "${BOOST_MINOR_VERSION}" )

FROM_BOOST_VERSION=${BOOST_MAJOR_VERSION}.${BOOST_MINOR_VERSION}
AC_MSG_NOTICE( @FROM_BOOST_VERSION@ == "${FROM_BOOST_VERSION}" )

BOOST_MINOR_VERSION2=[`python -c "print ${BOOST_MINOR_VERSION} + 1"`]

TO_BOOST_VERSION=${BOOST_MAJOR_VERSION}.${BOOST_MINOR_VERSION2}
AC_MSG_NOTICE( @TO_BOOST_VERSION@ == "${TO_BOOST_VERSION}" )

AC_SUBST(FROM_BOOST_VERSION)
AC_SUBST(TO_BOOST_VERSION)

AC_LANG_RESTORE
CPPFLAGS=${STORE_CPPFLAGS}
CXXFLAGS=${STORE_CXXFLAGS}
LDFLAGS=${STORE_LDFLAGS}
])


dnl --------------------------------------------------------------------------------
