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
AC_DEFUN([CONFFLU_CHECK_PROJECT_VERSION1],
[
  AC_MSG_NOTICE(define package build version)
  
  AC_SUBST(BUILD_VERSION)
  
  AC_SUBST(NUMBER_PART_VERSION)
  AC_SUBST(SYMBOLICAL_PART_VERSION)
  
  AC_ARG_WITH( [build_version],
             AC_HELP_STRING( [--with-build-version=<build version>],
                             [use <build version> to define package build version,"1" by default] ),
             [],
             [ with_build_version=1 ]  )

  if test "x${with_build_version}" = "xno" ; then
     with_build_version=""
  fi

  BUILD_VERSION=${with_build_version}
  
  AC_MSG_NOTICE( @BUILD_VERSION@ == "${BUILD_VERSION}" )
  
  NUMBER_PART_VERSION=[`echo ${PACKAGE_VERSION} | sed -e "s/-[A-z,a-z]*$//"`]
  SYMBOLICAL_PART_VERSION=[`echo ${PACKAGE_VERSION} | sed -e "s/^${NUMBER_PART_VERSION}-//"`]

])


dnl --------------------------------------------------------------------------------

