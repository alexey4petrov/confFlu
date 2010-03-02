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
dnl See http://sourceforge.net/projects/pyfoam
dnl
dnl Author : Alexey PETROV
dnl


dnl --------------------------------------------------------------------------------
AC_DEFUN([CONFFOAM_CHECK_BOOST_PROGRAM_OPTIONS],
[
AC_CHECKING(for Boost "program_options" library)

AC_REQUIRE([CONFFOAM_CHECK_BOOST])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS

BOOST_PROGRAM_OPTIONS_LDFLAGS="${BOOST_LDFLAGS} -lboost_program_options${BOOST_LIBSUFFIX}"
AC_SUBST(BOOST_PROGRAM_OPTIONS_LDFLAGS)

boost_program_options_ok=no

dnl --------------------------------------------------------------------------------
dnl Check for Boost "program_options" header files
if test "x${boost_libraries_ok}" = "xyes" ; then
   CPPFLAGS="${BOOST_CPPFLAGS}"
   CXXFLAGS="${BOOST_CXXFLAGS}"

   AC_CHECK_HEADERS( [boost/program_options.hpp], [ boost_program_options_ok=yes ], [ boost_program_options_ok=no ] )
fi

dnl --------------------------------------------------------------------------------
dnl Check for Boost "program_options" library
if test "x${boost_program_options_ok}" = "xyes" ; then
   AC_CHECK_FILE( [${with_boost_libraries}/libboost_program_options${BOOST_LIBSUFFIX}.so], [ boost_program_options_ok=yes ], [ boost_program_options_ok=no ] )
fi

if test "x${boost_program_options_ok}" = "xyes" ; then
   LDFLAGS="${BOOST_PROGRAM_OPTIONS_LDFLAGS}"

   AC_MSG_CHECKING( Boost "program options" functionality )
   AC_LINK_IFELSE( [ AC_LANG_PROGRAM( [ #include <boost/program_options.hpp> ], [ boost::program_options::options_description() ] ) ],
                   [ boost_program_options_ok=yes ],
                   [ boost_program_options_ok=no ] )
   AC_MSG_RESULT( ${boost_program_options_ok} )
fi

dnl --------------------------------------------------------------------------------
ENABLE_BOOST_PROGRAM_OPTIONS="${boost_program_options_ok}"
AC_SUBST(ENABLE_BOOST_PROGRAM_OPTIONS)

AC_LANG_RESTORE
])
