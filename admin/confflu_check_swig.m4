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
AC_DEFUN([CONFFLU_CHECK_SWIG],dnl
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


dnl ---------------------------------------------------------------------------
SWIG_VERSION=[`swig -version | grep "SWIG Version" | sed -e "s/SWIG Version //g"`]
AC_SUBST(SWIG_VERSION)
AC_MSG_NOTICE( @SWIG_VERSION@ == "${SWIG_VERSION}" )

dnl----------------------------------------------------------------------------
dnl The last number( minor version ) of swig version may be the two or one digit number,
dnl so the numeric string of swig version must be different.
dnl For example 1.3.40 or 2.0.6 ( 40 or 6 ), so numeric string of swig version equals 010340 or 020106

dnl Extract minor version
SWIG_MINOR_VERSION=[`echo ${SWIG_VERSION} | sed -e"s%^\([1-9]\)\.\([0-9]\)\.\([0-9]\+\).*%\3%g"`]

dnl Check minor version ( one or two digit number )
RESULT_DIVIDING_BY_10=[`python -c "print ${SWIG_MINOR_VERSION} / 10"`]
if test ${RESULT_DIVIDING_BY_10} -eq 0; then
dnl one digit number of minor version ( 2.0.6 )
SWIG_NUMERIC_VERSION=[`echo ${SWIG_VERSION} | sed -e"s%^\([1-9]\)\.\([0-9]\)\.\([0-9]\).*%0\10\20${SWIG_MINOR_VERSION}%g"`]
else
dnl two digit number of minor version( 1.3.40 )
SWIG_NUMERIC_VERSION=[`echo ${SWIG_VERSION} | sed -e"s%^\([1-9]\)\.\([0-9]\)\.\([0-9]\).*%0\10\2${SWIG_MINOR_VERSION}%g"`]
fi


dnl----------------------------------------------------------------------------
SWIG_WARNINGS="-w508" dnl Declaration of 'XXX' shadows declaration accessible via 'YYY"
SWIG_WARNINGS="${SWIG_WARNINGS} -w317" dnl Specialization of non-template 'XXX'
SWIG_WARNINGS="${SWIG_WARNINGS} -w509" dnl Overloaded method 'XXX' is shadowed by 'YYY'
SWIG_WARNINGS="${SWIG_WARNINGS} -w503" dnl Can't wrap 'XXX' unless renamed to a valid identifier
SWIG_WARNINGS="${SWIG_WARNINGS} -w462" dnl Unable to set dimensionless array variable
SWIG_WARNINGS="${SWIG_WARNINGS} -w473" dnl Returning a pointer or reference in a director method is not recommended

if test ${SWIG_NUMERIC_VERSION} -lt "020000"; then
   SWIG_WARNINGS="${SWIG_WARNINGS} -w312" # Nested class not currently supported (ignored)
else
   SWIG_WARNINGS="${SWIG_WARNINGS} -w325" # Nested class not currently supported (ignored)
fi

if test ${SWIG_NUMERIC_VERSION} -eq "020006"; then
   SWIG_WARNINGS="${SWIG_WARNINGS} -w521" # Illegal destructor name.Ignored
fi


AC_SUBST(SWIG_WARNINGS)
AC_MSG_NOTICE( @SWIG_WARNINGS@ == "${SWIG_WARNINGS}" )


dnl --------------------------------------------------------------------------------
])


dnl --------------------------------------------------------------------------------
