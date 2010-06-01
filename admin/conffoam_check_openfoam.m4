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
AC_DEFUN([CONFFOAM_CHECK_OPENFOAM],dnl
[
AC_CHECKING(for OpenFOAM library)

FOAM_VERSION=""
AC_SUBST(FOAM_VERSION)

AC_SUBST(ENABLE_OPENFOAM)

openfoam_ok=no


dnl --------------------------------------------------------------------------------
AC_MSG_CHECKING(location of the OpenFOAM installation)
if test -d "${WM_PROJECT_DIR}" ; then
   openfoam_ok=yes
fi
AC_MSG_RESULT(${openfoam_ok})


dnl --------------------------------------------------------------------------------
if test "x${openfoam_ok}" = "xyes" ; then
   project_version=[`echo ${WM_PROJECT_VERSION} | sed  -e"s%\([0-9\.]\+\)-dev%\1%g"`]
   number_counter=[`echo ${project_version} | sed -e"s%[^\.]%%g" | wc --bytes`]

   if test "x${number_counter}" = "x2" ; then
      FOAM_VERSION=[`echo ${project_version} | sed -e"s%^\([1-9]\)\.\([0-9]\).*%0\10\200%g"`]
   fi

   if test "x${number_counter}" = "x3" ; then
      FOAM_VERSION=[`echo ${project_version} | sed -e"s%^\([1-9]\)\.\([0-9]\)\.\([0-9]\).*%0\10\20\3%g"`]
   fi
   AC_MSG_NOTICE( @FOAM_VERSION@ == "${FOAM_VERSION}" )
fi


dnl --------------------------------------------------------------------------------
if test "x${openfoam_ok}" = "xno" ; then
   AC_MSG_WARN([it is neceesary to source OpenFOAM environment first])
fi


dnl --------------------------------------------------------------------------------
ENABLE_OPENFOAM=${openfoam_ok}
])


dnl --------------------------------------------------------------------------------
