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


dnl --------------------------------------------------------------------------------
AC_DEFUN([CONFFOAM_PRINT_SUMMURY],
[
  variables=$*
  for var in $variables ; do
    eval toto=\$$var
    if test x$toto != "x" ; then
      printf "   %10s : " `echo \$var | sed -e "s,_ok,,"`
      eval echo \$$var
    fi
  done
])
dnl --------------------------------------------------------------------------------

AC_DEFUN([CONFFOAM_CHECK_MANDATORY],
[
  variables=$*
  for var in $variables ; do
    eval toto=\$$var
    if test x$toto != "xyes" ; then
        echo "FATAL ERROR: some mandatory products are missing."
	echo "Installing the missing products is required before running the configure script".
    	exit 1
    fi
  done  
])
dnl --------------------------------------------------------------------------------
