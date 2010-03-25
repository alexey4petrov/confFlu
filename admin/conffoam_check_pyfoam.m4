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
AC_DEFUN([CONFFOAM_CHECK_PYFOAM],
[
AC_CHECKING(for pyFoam package)

AC_REQUIRE([CONFFOAM_CHECK_OPENFOAM])
AC_REQUIRE([CONFFOAM_CHECK_SWIG])
AC_REQUIRE([CONFFOAM_CHECK_PYTHON])

AC_SUBST(ENABLE_PYFOAM)

pyfoam_ok=no

dnl --------------------------------------------------------------------------------
AC_ARG_WITH( [pyfoam],
             AC_HELP_STRING( [--with-pyfoam=<path>],
                             [use <path> to look for pyfoam installation] ),
             [pyfoam_root_dir=${withval}],
             [withval=yes])
   
dnl --------------------------------------------------------------------------------
if test "x${withval}" = "xyes" ; then
   if test ! "x${PYFOAM_ROOT_DIR}" = "x" && test -d ${PYFOAM_ROOT_DIR} ; then
      pyfoam_root_dir=${PYFOAM_ROOT_DIR}
   fi
fi

if test "x${withval}" = "xno" ; then
   pyfoam_ok=no
fi

dnl --------------------------------------------------------------------------------
AC_CHECK_FILE( [${pyfoam_root_dir}/Foam/_pyfoam.so], [ pyfoam_ok=yes ], [ pyfoam_ok=no ] )

dnl --------------------------------------------------------------------------------
if test "x${pyfoam_ok}" = "xno" ; then
   AC_MSG_WARN([use either \${PYFOAM_ROOT_DIR} or --with-pyfoam=<path>])
fi

dnl --------------------------------------------------------------------------------
ENABLE_PYFOAM=${pyfoam_ok}
])


dnl --------------------------------------------------------------------------------
