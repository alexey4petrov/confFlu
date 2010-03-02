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
AC_DEFUN([CONFFOAM_CHECK_UNV2FOAM],dnl
[
AC_CHECKING(for unv2foam package)

AC_REQUIRE([CONFFOAM_CHECK_OPENFOAM])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS

UNV2FOAM_CPPFLAGS=""
AC_SUBST(UNV2FOAM_CPPFLAGS)

UNV2FOAM_CXXFLAGS=""
AC_SUBST(UNV2FOAM_CXXFLAGS)

UNV2FOAM_LDFLAGS=""
AC_SUBST(UNV2FOAM_LDFLAGS)

AC_SUBST(ENABLE_UNV2FOAM)

unv2foam_ok=no

dnl --------------------------------------------------------------------------------
AC_ARG_WITH( [unv2foam],
             AC_HELP_STRING( [--with-unv2foam=<path>],
                             [use <path> to look for unv2foam installation] ),
             [unv2foam_root_dir=${withval}],
             [withval=yes])
   
dnl --------------------------------------------------------------------------------
if test "x${withval}" = "xyes" ; then
   if test ! "x${UNV2FOAM_ROOT_DIR}" = "x" && test -d ${UNV2FOAM_ROOT_DIR} ; then
      unv2foam_root_dir=${UNV2FOAM_ROOT_DIR}
   fi
fi

dnl --------------------------------------------------------------------------------
AC_CHECK_FILE( [${unv2foam_root_dir}/lib/unv2foam.H], [ unv2foam_ok=yes ], [ unv2foam_ok=no ] )

if test "x${unv2foam_ok}" = "xyes" ; then
   UNV2FOAM_CPPFLAGS="-I${unv2foam_root_dir}/lib"
   CPPFLAGS="${UNV2FOAM_CPPFLAGS}"

   dnl AC_CHECK_HEADERS( [unv2foam.H], [ unv2foam_ok=yes ], [ unv2foam_ok=no ] )
fi

dnl --------------------------------------------------------------------------------
AC_CHECK_FILE( [${unv2foam_root_dir}/lib/libunv2foam.so], [ unv2foam_ok=yes ], [ unv2foam_ok=no ] )

if test "x${unv2foam_ok}" = "xyes" ; then
   UNV2FOAM_CXXFLAGS=""

   UNV2FOAM_LDFLAGS="-L${unv2foam_root_dir}/lib -lunv2foam"

   dnl AC_MSG_CHECKING( for linking to unv2foam library )
   dnl AC_LINK_IFELSE( [ AC_LANG_PROGRAM( [ #include <unv2foam.H> ], [ Foam::unv2foam( "dummy", Foam::Time() ) ] ) ],
   dnl                 [ unv2foam_ok=yes ],
   dnl                 [ unv2foam_ok=no ] )
   dnl AC_MSG_RESULT( ${unv2foam_ok} )
fi

if test "x${unv2foam_ok}" = "xno" ; then
   AC_MSG_WARN([use either \${UNV2FOAM_ROOT_DIR} or --with-unv2foam=<path>])
fi

dnl --------------------------------------------------------------------------------
ENABLE_UNV2FOAM=${unv2foam_ok}
])

