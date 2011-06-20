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
AC_DEFUN([CONFFOAM_CHECK_BLOCKLDUMATRIXLIB],dnl
[
AC_CHECKING(for blockLduMatrixLib package)

AC_REQUIRE([CONFFOAM_CHECK_OPENFOAM])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS

BLOCKLDUMATRIXLIB_CPPFLAGS=""
AC_SUBST(BLOCKLDUMATRIXLIB_CPPFLAGS)

BLOCKLDUMATRIXLIB_CXXFLAGS=""
AC_SUBST(BLOCKLDUMATRIXLIB_CXXFLAGS)

BLOCKLDUMATRIXLIB_LDFLAGS=""
AC_SUBST(BLOCKLDUMATRIXLIB_LDFLAGS)

AC_SUBST(ENABLE_BLOCKLDUMATRIXLIB)

blockldumatrixlib_ok=no

dnl --------------------------------------------------------------------------------
AC_ARG_WITH( [blockldumatrixlib],
             AC_HELP_STRING( [--with-blockldumatrixlib=<path>],
                             [use <path> to look for blockLduMatrixLib installation] ),
             [blockldumatrixlib_root_dir=${withval}],
             [withval=yes])
   

dnl --------------------------------------------------------------------------------
if test ! "x${withval}" = "xno" ; then
   if test "x${withval}" = "xyes" ; then
      if test ! "x${BLOCKLDUMATRIXLIB_ROOT_DIR}" = "x" && test -d ${BLOCKLDUMATRIXLIB_ROOT_DIR} ; then
         blockldumatrixlib_root_dir=${BLOCKLDUMATRIXLIB_ROOT_DIR}
      fi
   fi

   AC_CHECK_FILE( [${blockldumatrixlib_root_dir}/lnInclude], [ blockldumatrixlib_ok=yes ], [ blockldumatrixlib_ok=no ] )
   AC_CHECK_FILE( [${blockldumatrixlib_root_dir}/lib/libblockLduMatrix.so], [ blockldumatrixlib_ok=yes ], [ blockldumatrixlib_ok=no ] )

   if test "x${blockldumatrixlib_ok}" = "xyes" ; then
      BLOCKLDUMATRIXLIB_CPPFLAGS="-I${blockldumatrixlib_root_dir}/lnInclude"

      BLOCKLDUMATRIXLIB_CXXFLAGS=""

      BLOCKLDUMATRIXLIB_LDFLAGS="-L${blockldumatrixlib_root_dir}/lib -lblockLduMatrix"
   fi
fi

dnl --------------------------------------------------------------------------------
if test "x${blockldumatrixlib_ok}" = "xno" ; then
   AC_MSG_WARN([use either \${BLOCKLDUMATRIXLIB_ROOT_DIR} or --with-blockldumatrixlib=<path>])
fi

dnl --------------------------------------------------------------------------------
ENABLE_BLOCKLDUMATRIXLIB=${blockldumatrixlib_ok}
])


dnl --------------------------------------------------------------------------------
