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
AC_DEFUN([CONFFOAM_CHECK_BLOCKFVMATRIXLIB],dnl
[
AC_CHECKING(for blockFvMatrixLib package)

AC_REQUIRE([CONFFOAM_CHECK_BLOCKLDUMATRIXLIB])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS

BLOCKFVMATRIXLIB_CPPFLAGS="${BLOCKLDUMATRIXLIB_CPPFLAGS}"
AC_SUBST(BLOCKFVMATRIXLIB_CPPFLAGS)

BLOCKFVMATRIXLIB_CXXFLAGS="${BLOCKLDUMATRIXLIB_CXXFLAGS}"
AC_SUBST(BLOCKFVMATRIXLIB_CXXFLAGS)

BLOCKFVMATRIXLIB_LDFLAGS="${BLOCKLDUMATRIXLIB_LDFLAGS}"
AC_SUBST(BLOCKFVMATRIXLIB_LDFLAGS)

AC_SUBST(ENABLE_BLOCKFVMATRIXLIB)

blockfvmatrixlib_ok=no

dnl --------------------------------------------------------------------------------
AC_ARG_WITH( [blockfvmatrixlib],
             AC_HELP_STRING( [--with-blockfvmatrixlib=<path>],
                             [use <path> to look for blockFvMatrixLib installation] ),
             [blockfvmatrixlib_root_dir=${withval}],
             [withval=yes])
   

dnl --------------------------------------------------------------------------------
if test ! "x${withval}" = "xno" ; then
   if test "x${withval}" = "xyes" ; then
      if test ! "x${BLOCKFVMATRIXLIB_ROOT_DIR}" = "x" && test -d ${BLOCKFVMATRIXLIB_ROOT_DIR} ; then
         blockfvmatrixlib_root_dir=${BLOCKFVMATRIXLIB_ROOT_DIR}
      fi
   fi

   AC_CHECK_FILE( [${blockfvmatrixlib_root_dir}/lnInclude], [ blockfvmatrixlib_ok=yes ], [ blockfvmatrixlib_ok=no ] )
   AC_CHECK_FILE( [${blockfvmatrixlib_root_dir}/lib/libblockFvMatrix.so], [ blockfvmatrixlib_ok=yes ], [ blockfvmatrixlib_ok=no ] )

   if test "x${blockfvmatrixlib_ok}" = "xyes" ; then
      BLOCKFVMATRIXLIB_CPPFLAGS="${BLOCKFVMATRIXLIB_CPPFLAGS} -I${blockfvmatrixlib_root_dir}/lnInclude"

      BLOCKFVMATRIXLIB_CXXFLAGS="${BLOCKFVMATRIXLIB_CXXFLAGS}"

      BLOCKFVMATRIXLIB_LDFLAGS="${BLOCKFVMATRIXLIB_LDFLAGS} -L${blockfvmatrixlib_root_dir}/lib -lblockFvMatrix"
   fi
fi

dnl --------------------------------------------------------------------------------
if test "x${blockfvmatrixlib_ok}" = "xno" ; then
   AC_MSG_WARN([use either \${BLOCKFVMATRIXLIB_ROOT_DIR} or --with-blockfvmatrixlib=<path>])
fi

dnl --------------------------------------------------------------------------------
ENABLE_BLOCKFVMATRIXLIB=${blockfvmatrixlib_ok}
])


dnl --------------------------------------------------------------------------------
