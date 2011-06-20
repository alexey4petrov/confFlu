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
AC_DEFUN([CONFFOAM_CHECK_FOAM2MED],
[
AC_CHECKING(for unv2foam package)

AC_REQUIRE([CONFFOAM_CHECK_SALOME_KERNEL])
AC_REQUIRE([CONFFOAM_CHECK_SALOME_MED])
AC_REQUIRE([CONFFOAM_CHECK_SALOME_GUI])
AC_REQUIRE([CONFFOAM_CHECK_SALOME_VISU])

AC_REQUIRE([CONFFOAM_CHECK_HDF5])
AC_REQUIRE([CONFFOAM_CHECK_VTK])
AC_REQUIRE([CONFFOAM_CHECK_BOOST_PROGRAM_OPTIONS])

AC_SUBST(ENABLE_FOAM2MED)

foam2med_ok=no

dnl --------------------------------------------------------------------------------
AC_ARG_WITH( [foam2med],
             AC_HELP_STRING( [--with-foam2med=<path>],
                             [use <path> to look for foam2med installation] ),
             [foam2med_root_dir=${withval}],
             [withval=yes])
   
dnl --------------------------------------------------------------------------------
if test "x${withval}" = "xyes" ; then
   if test ! "x${FOAM2MED_ROOT_DIR}" = "x" && test -d ${FOAM2MED_ROOT_DIR} ; then
      foam2med_root_dir=${FOAM2MED_ROOT_DIR}
   fi
fi

if test "x${withval}" = "xno" ; then
   foam2med_ok=no
fi

dnl --------------------------------------------------------------------------------
AC_CHECK_FILE( [${foam2med_root_dir}/vtk2med], [ foam2med_ok=yes ], [ foam2med_ok=no ] )

AC_CHECK_FILE( [${foam2med_root_dir}/foam2med.py], [ foam2med_ok=yes ], [ foam2med_ok=no ] )

dnl --------------------------------------------------------------------------------
if test "x${foam2med_ok}" = "xno" ; then
   AC_MSG_WARN([use either \${FOAM2MED_ROOT_DIR} or --with-foam2med=<path>])
fi

dnl --------------------------------------------------------------------------------
ENABLE_FOAM2MED=${foam2med_ok}
])


dnl --------------------------------------------------------------------------------
