dnl VulaSHAKA (Simultaneous Neutronic, Fuel Performance, Heat And Kinetics Analysis)
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
dnl See https://vulashaka.svn.sourceforge.net/svnroot/vulashaka/conffoam
dnl
dnl Author : Alexey PETROV
dnl


dnl --------------------------------------------------------------------------------
AC_DEFUN([CONFFOAM_CHECK_DIFFUSIONFOAMLIB],dnl
[
AC_CHECKING(for diffusionFoamLib package)

AC_REQUIRE([CONFFOAM_CHECK_BLOCKFVMATRIXLIB])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS

DIFFUSIONFOAMLIB_CPPFLAGS="${BLOCKFVMATRIXLIB_CPPFLAGS}"
AC_SUBST(DIFFUSIONFOAMLIB_CPPFLAGS)

DIFFUSIONFOAMLIB_CXXFLAGS="${BLOCKFVMATRIXLIB_CXXFLAGS}"
AC_SUBST(DIFFUSIONFOAMLIB_CXXFLAGS)

DIFFUSIONFOAMLIB_LDFLAGS="${BLOCKFVMATRIXLIB_LDFLAGS}"
AC_SUBST(DIFFUSIONFOAMLIB_LDFLAGS)

AC_SUBST(ENABLE_DIFFUSIONFOAMLIB)

diffusionfoamlib_ok=no

dnl --------------------------------------------------------------------------------
AC_ARG_WITH( [diffusionfoamlib],
             AC_HELP_STRING( [--with-diffusionfoamlib=<path>],
                             [use <path> to look for diffusionFoamLib installation] ),
             [diffusionfoamlib_root_dir=${withval}],
             [withval=yes])
   

dnl --------------------------------------------------------------------------------
if test ! "x${withval}" = "xno" ; then
   if test "x${withval}" = "xyes" ; then
      if test ! "x${DIFFUSIONFOAMLIB_ROOT_DIR}" = "x" && test -d ${DIFFUSIONFOAMLIB_ROOT_DIR} ; then
         diffusionfoamlib_root_dir=${DIFFUSIONFOAMLIB_ROOT_DIR}
      fi
   fi

   AC_CHECK_FILE( [${diffusionfoamlib_root_dir}/lnInclude], [ diffusionfoamlib_ok=yes ], [ diffusionfoamlib_ok=no ] )
   AC_CHECK_FILE( [${diffusionfoamlib_root_dir}/lib/libdiffusionFoam.so], [ diffusionfoamlib_ok=yes ], [ diffusionfoamlib_ok=no ] )

   if test "x${diffusionfoamlib_ok}" = "xyes" ; then
      DIFFUSIONFOAMLIB_CPPFLAGS="${DIFFUSIONFOAMLIB_CPPFLAGS} -I${diffusionfoamlib_root_dir}/lnInclude"

      DIFFUSIONFOAMLIB_CXXFLAGS="${DIFFUSIONFOAMLIB_CXXFLAGS}"

      DIFFUSIONFOAMLIB_LDFLAGS="${DIFFUSIONFOAMLIB_LDFLAGS} -L${diffusionfoamlib_root_dir}/lib -ldiffusionFoam"
   fi
fi

dnl --------------------------------------------------------------------------------
if test "x${diffusionfoamlib_ok}" = "xno" ; then
   AC_MSG_WARN([use either \${DIFFUSIONFOAMLIB_ROOT_DIR} or --with-diffusionfoamlib=<path>])
fi

dnl --------------------------------------------------------------------------------
ENABLE_DIFFUSIONFOAMLIB=${diffusionfoamlib_ok}
])


dnl --------------------------------------------------------------------------------
