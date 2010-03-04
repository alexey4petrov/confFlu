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
dnl See https://csrcs.pbmr.co.za/svn/nea/prototypes/reaktor/pyfoam
dnl
dnl Author : Alexey PETROV
dnl


dnl --------------------------------------------------------------------------------
AC_DEFUN([CONFFOAM_CHECK_BOOST_SHARED_PTR],
[
AC_CHECKING(for Boost "shared_ptr" library)

AC_REQUIRE([CONFFOAM_CHECK_BOOST])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS

boost_shared_ptr_ok=no

dnl --------------------------------------------------------------------------------
if test "x${boost_includes_ok}" = "xyes" ; then
   CPPFLAGS="${BOOST_CPPFLAGS}"
   CXXFLAGS="${BOOST_CXXFLAGS}"

   AC_CHECK_HEADERS( [boost/shared_ptr.hpp], [ boost_shared_ptr_ok=yes ], [ boost_shared_ptr_ok=no ] )
fi

if test "x${boost_shared_ptr_ok}" = "xyes" ; then
   AC_MSG_CHECKING( Boost "shared_ptr" functionality )
   AC_LINK_IFELSE( [ AC_LANG_PROGRAM( [ #include <boost/shared_ptr.hpp> ], [ boost::shared_ptr< int >( new int ) ] ) ],
                   [ boost_shared_ptr_ok=yes ],
                   [ boost_shared_ptr_ok=no ] )
   AC_MSG_RESULT( ${boost_shared_ptr_ok} )
fi

dnl --------------------------------------------------------------------------------
ENABLE_BOOST_SHARED_PTR="${boost_shared_ptr_ok}"
AC_SUBST(ENABLE_BOOST_SHARED_PTR)

AC_LANG_RESTORE
])


dnl --------------------------------------------------------------------------------
