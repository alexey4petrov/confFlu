dnl confFlu - pythonFlu configuration package
dnl Copyright (C) 2010- Alexey Petrov
dnl Copyright (C) 2009 Pebble Bed Modular Reactor (Pty) Limited (PBMR)
dnl 
dnl This library is free software; you can redistribute it and/or 
dnl modify it under the terms of the GNU Lesser General Public 
dnl License as published by the Free Software Foundation; either 
dnl version 2.1 of the License. 
dnl 
dnl This library is distributed in the hope that it will be useful, 
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of 
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
dnl Lesser General Public License for more details. 
dnl 
dnl You should have received a copy of the GNU Lesser General Public 
dnl License along with this library; if not, write to the Free Software 
dnl Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA 
dnl 
dnl See http://sourceforge.net/projects/pythonflu
dnl
dnl Author : Alexey PETROV
dnl


dnl --------------------------------------------------------------------------------
AC_DEFUN([CONFFLU_CHECK_BOOST_SERIALIZATION],
[
AC_CHECKING(for Boost "serialization" library)

AC_REQUIRE([CONFFLU_CHECK_BOOST])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS
STORE_CPPFLAGS=${CPPFLAGS}
STORE_CXXFLAGS=${CXXFLAGS}


BOOST_SERIALIZATION_LIBS="-lboost_serialization${BOOST_LIBSUFFIX}"
AC_SUBST(BOOST_SERIALIZATION_LIBS)

boost_serialization_ok=no

dnl --------------------------------------------------------------------------------
dnl Check for Boost "serialization" header files
if test "x${boost_libraries_ok}" = "xyes" ; then
   CPPFLAGS="${BOOST_CPPFLAGS}"
   CXXFLAGS="${BOOST_CXXFLAGS}"

   AC_CHECK_HEADERS( [boost/serialization/serialization.hpp], [ boost_serialization_ok=yes ], [ boost_serialization_ok=no ] )
fi

dnl --------------------------------------------------------------------------------
dnl Check for Boost "serialization" library
if test "x${boost_serialization_ok}" = "xyes" ; then
   AC_CHECK_FILE( [${with_boost_libraries}/libboost_serialization${BOOST_LIBSUFFIX}.so], [ boost_serialization_ok=yes ], [ boost_serialization_ok=no ] )
fi

dnl --------------------------------------------------------------------------------
ENABLE_BOOST_SERIALIZATION="${boost_serialization_ok}"
AC_SUBST(ENABLE_BOOST_SERIALIZATION)

AC_LANG_RESTORE
CPPFLAGS=${STORE_CPPFLAGS}
CXXFLAGS=${STORE_CXXFLAGS}
])


dnl --------------------------------------------------------------------------------
