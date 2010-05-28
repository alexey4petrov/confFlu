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
dnl See https://vulashaka.svn.sourceforge.net/svnroot/vulashaka/diffusionFoam
dnl
dnl Author : Alexey PETROV
dnl


dnl --------------------------------------------------------------------------------
AC_DEFUN([CONFFOAM_CHECK_DIFFUSIONFOAM],dnl
[
AC_CHECKING(for diffusionFoam package)

AC_REQUIRE([CONFFOAM_CHECK_OPENFOAM])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS


dnl --------------------------------------------------------------------------------
AC_SUBST(BLOCKLDUMATRIXLIB_CPPFLAGS)
AC_SUBST(BLOCKLDUMATRIXLIB_CXXFLAGS)
AC_SUBST(BLOCKLDUMATRIXLIB_LDFLAGS)

AC_SUBST(ENABLE_BLOCKLDUMATRIXLIB)


dnl --------------------------------------------------------------------------------
AC_SUBST(BLOCKFVMATRIXLIB_CPPFLAGS)
AC_SUBST(BLOCKFVMATRIXLIB_CXXFLAGS)
AC_SUBST(BLOCKFVMATRIXLIB_LDFLAGS)

AC_SUBST(ENABLE_BLOCKFVMATRIXLIB)


dnl --------------------------------------------------------------------------------
AC_SUBST(DIFFUSIONFOAMLIB_CPPFLAGS)
AC_SUBST(DIFFUSIONFOAMLIB_CXXFLAGS)
AC_SUBST(DIFFUSIONFOAMLIB_LDFLAGS)

AC_SUBST(ENABLE_DIFFUSIONFOAMLIB)


dnl --------------------------------------------------------------------------------
AC_SUBST(DIFFUSIONFOAM_CPPFLAGS)
AC_SUBST(DIFFUSIONFOAM_CXXFLAGS)
AC_SUBST(DIFFUSIONFOAM_LDFLAGS)

AC_SUBST(ENABLE_DIFFUSIONFOAM)

diffusionfoam_ok=no

dnl --------------------------------------------------------------------------------
AC_ARG_WITH( [diffusionfoam],
             AC_HELP_STRING( [--with-diffusionfoam=<path>],
                             [use <path> to look for diffusionFoam installation] ),
             [diffusionfoam_root_dir=${withval}],
             [withval=yes])
   

dnl --------------------------------------------------------------------------------
if test ! "x${withval}" = "xno" ; then
   if test "x${withval}" = "xyes" ; then
      if test ! "x${DIFFUSIONFOAM_ROOT_DIR}" = "x" && test -d ${DIFFUSIONFOAM_ROOT_DIR} ; then
         diffusionfoam_root_dir=${DIFFUSIONFOAM_ROOT_DIR}
      fi
   fi

   AC_CHECK_FILE( [${diffusionfoam_root_dir}], [ diffusionfoam_ok=yes ], [ diffusionfoam_ok=no ] )

   if test "x${diffusionfoam_ok}" = "xyes" ; then
      BLOCKLDUMATRIXLIB_CPPFLAGS="-I${diffusionfoam_root_dir}/wikki/blockLduMatrixLib/lnInclude"
      BLOCKFVMATRIXLIB_CPPFLAGS="${BLOCKLDUMATRIXLIB_CPPFLAGS} -I${diffusionfoam_root_dir}/blockFvMatrixLib/lnInclude"
      DIFFUSIONFOAMLIB_CPPFLAGS="${BLOCKFVMATRIXLIB_CPPFLAGS} -I${diffusionfoam_root_dir}/blockFvMatrixLib/lnInclude"
      DIFFUSIONFOAM_CPPFLAGS="${DIFFUSIONFOAMLIB_CPPFLAGS} -I${diffusionfoam_root_dir}/diffusionFoamLib/lnInclude"

      BLOCKLDUMATRIXLIB_CXXFLAGS=""
      BLOCKFVMATRIXLIB_CXXFLAGS="${BLOCKLDUMATRIXLIB_CXXFLAGS}"
      DIFFUSIONFOAMLIB_CXXFLAGS="${BLOCKFVMATRIXLIB_CXXFLAGS}"
      DIFFUSIONFOAM_CXXFLAGS="${DIFFUSIONFOAMLIB_CXXFLAGS}"

      BLOCKLDUMATRIXLIB_LDFLAGS="-L${diffusionfoam_root_dir}/lib"
      BLOCKFVMATRIXLIB_LDFLAGS="${BLOCKLDUMATRIXLIB_LDFLAGS} -lblockLduMatrix"
      DIFFUSIONFOAMLIB_LDFLAGS="${BLOCKFVMATRIXLIB_LDFLAGS} -lblockFvMatrix"
      DIFFUSIONFOAM_LDFLAGS="${DIFFUSIONFOAMLIB_LDFLAGS} -ldiffusionFoam"
   fi
fi

dnl --------------------------------------------------------------------------------
if test "x${diffusionfoam_ok}" = "xno" ; then
   AC_MSG_WARN([use either \${DIFFUSIONFOAM_ROOT_DIR} or --with-diffusionfoam=<path>])
fi

dnl --------------------------------------------------------------------------------
ENABLE_DIFFUSIONFOAM=${diffusionfoam_ok}
])


dnl --------------------------------------------------------------------------------
