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
AC_DEFUN([CONFFLU_CHECK_SALOME_SMESH],
[
AC_CHECKING(for SALOME SMESH package)

AC_REQUIRE([CHECK_KERNEL])
AC_REQUIRE([CHECK_GEOM])
AC_REQUIRE([CHECK_MED])
AC_REQUIRE([CHECK_SMESH])

SALOME_SMESH_CXXFLAGS=${SMESH_CXXFLAGS}
AC_SUBST(SALOME_SMESH_CXXFLAGS)

SALOME_SMESH_LDFLAGS=${SMESH_LDFLAGS}
AC_SUBST(SALOME_SMESH_LDFLAGS)

SALOME_SMESH_LDRPATH=`echo ${SMESH_LDFLAGS} | sed -e "s%-L%-Wl,-rpath-link %g"`
AC_SUBST(SALOME_SMESH_LDRPATH)

salome_smesh_ok=${SMesh_ok}
])


dnl --------------------------------------------------------------------------------
