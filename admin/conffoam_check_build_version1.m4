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
AC_DEFUN([CONFFOAM_CHECK_BUILD_VERSION1],
[
  AC_MSG_NOTICE(define package build version)
  
  AC_SUBST(BUILD_VERSION)
  
  AC_ARG_VAR(buid_version, define package build version, build_version=<build version>)

  BUILD_VERSION=${build_version}
  
  if test "x${build_version}" = "x"; then
     BUILD_VERSION=1
  fi
    
  AC_MSG_NOTICE( @BUILD_VERSION@ == "${BUILD_VERSION}" )
    
])


dnl --------------------------------------------------------------------------------

