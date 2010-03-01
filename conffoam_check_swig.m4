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
dnl See https://csrcs.pbmr.co.za/svn/nea/prototypes/reaktor/pyfoam
dnl
dnl Author : Alexey PETROV
dnl


AC_DEFUN([CONFFOAM_CHECK_SWIG],dnl
[
AC_CHECKING(for SWIG utitlity)

SWIG=""
AC_SUBST(SWIG)

swig_ok=no

dnl --------------------------------------------------------------------------------
AC_ARG_WITH( [swig],
             AC_HELP_STRING( [--with-swig=<path>],
		             [use <path> to look for swig utility] ),
             [],
	     [with_swig=`which swig`])
   
dnl --------------------------------------------------------------------------------
AC_CHECK_FILE( [${with_swig}], [ swig_ok=yes ], [ swig_ok=no ] )
if test "x${swig_ok}" = "xyes" ; then
   SWIG=${with_swig}
fi

dnl --------------------------------------------------------------------------------
if test "x${swig_ok}" = "xno" ; then
   AC_MSG_WARN( [use --with-swig=<path> to define SWIG installation] )
fi

dnl --------------------------------------------------------------------------------
])
