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
AC_DEFUN([CONFFOAM_CHECK_PARAFOAM],
[
AC_CHECKING(for paraFoam package)

AC_REQUIRE([CONFFOAM_CHECK_LOKI])
AC_REQUIRE([CONFFOAM_CHECK_BOOST_SERIALIZATION])
AC_REQUIRE([CONFFOAM_CHECK_BOOST_THREAD])

AC_REQUIRE([CONFFOAM_CHECK_OPENFOAM])
AC_REQUIRE([CONFFOAM_CHECK_DIFFUSIONFOAMLIB])

AC_SUBST(ENABLE_PARAFOAM)

parafoam_ok=no

dnl --------------------------------------------------------------------------------
AC_ARG_WITH( [parafoam],
             AC_HELP_STRING( [--with-parafoam=<path>],
                             [use <path> to look for parafoam installation] ),
             [parafoam_root_dir=${withval}],
             [withval=yes])
   
dnl --------------------------------------------------------------------------------
if test "x${withval}" = "xyes" ; then
   if test ! "x${PARAFOAM_ROOT_DIR}" = "x" && test -d ${PARAFOAM_ROOT_DIR} ; then
      parafoam_root_dir=${PARAFOAM_ROOT_DIR}
   fi
fi

if test "x${withval}" = "xno" ; then
   parafoam_ok=no
fi

dnl --------------------------------------------------------------------------------
AC_CHECK_FILE( [${parafoam_root_dir}/lib/libparallel_threading_base.so], [ parafoam_ok=yes ], [ parafoam_ok=no ] )

dnl --------------------------------------------------------------------------------
if test "x${parafoam_ok}" = "xno" ; then
   AC_MSG_WARN([use either \${PARAFOAM_ROOT_DIR} or --with-parafoam=<path>])
fi

dnl --------------------------------------------------------------------------------
ENABLE_PARAFOAM=${parafoam_ok}
])


dnl --------------------------------------------------------------------------------
