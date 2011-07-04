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
AC_DEFUN([CONFFLU_CHECK_SALOME_FOAM],
[
AC_CHECKING(for SALOME FOAM package)

AC_REQUIRE([CHECK_GEOM])
AC_REQUIRE([CHECK_SMESH])
AC_REQUIRE([CHECK_FOAM])

SALOME_FOAM_CXXFLAGS=${FOAM_CXXFLAGS}
AC_SUBST(SALOME_FOAM_CXXFLAGS)

SALOME_FOAM_LDFLAGS=${FOAM_LDFLAGS}
AC_SUBST(SALOME_FOAM_LDFLAGS)

SALOME_FOAM_LDRPATH=`echo ${FOAM_LDFLAGS} | sed -e "s%-L%-Wl,-rpath-link %g"`
AC_SUBST(SALOME_FOAM_LDRPATH)

salome_foam_ok=${FOAM_ok}
])


dnl --------------------------------------------------------------------------------
