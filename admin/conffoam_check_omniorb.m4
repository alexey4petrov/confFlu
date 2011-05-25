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
dnl See  http://sourceforge.net/projects/pythonflu
dnl
dnl Author : Alexey PETROV
dnl


dnl --------------------------------------------------------------------------------
AC_DEFUN([CONFFOAM_CHECK_OMNIORB],
[
echo "--------------------------------------------------------------------------------------"
AC_CHECKING(for omniORB environemnt)


dnl --------------------------------------------------------------------------------
AC_REQUIRE([AC_PROG_CC])
AC_REQUIRE([AC_PROG_CXX])
AC_REQUIRE([AC_PROG_CPP])
AC_REQUIRE([AC_PROG_CXXCPP])

omniORB_ok=yes

dnl --------------------------------------------------------------------------------
AC_LANG_SAVE
AC_LANG_CPLUSPLUS


dnl --------------------------------------------------------------------------------
AC_SUBST(OMNIORB_IDL)
AC_SUBST(OMNIORB_BIN)
AC_SUBST(OMNIORB_ROOT)
AC_SUBST(OMNIORB_LIB)
AC_SUBST(OMNIORB_INCLUDES)
AC_SUBST(OMNIORB_LIBS)


dnl --------------------------------------------------------------------------------
AC_PATH_PROG(OMNIORB_IDL, omniidl)
if test "x${OMNIORB_IDL}" = "x" ; then
  omniORB_ok=no
  AC_MSG_RESULT(omniORB binaries not in PATH variable)
else
  omniORB_ok=yes
fi

AC_SUBST(OMNIORB_IDL)


dnl --------------------------------------------------------------------------------
if  test "x${omniORB_ok}" = "xyes" ; then
  OMNIORB_BIN=`dirname ${OMNIORB_IDL}`
  OMNIORB_ROOT=`cd ${OMNIORB_BIN}/..; pwd`
  OMNIORB_LIB="${OMNIORB_ROOT}/lib"

  if test -d "${OMNIORB_ROOT}/include" ; then
    # if ${OMNIORB_ROOT}/include exists, there are a lot of chance that
    # this is omniORB4.x installed via configure && make && make install
    OMNIORB_VERSION=4
  else
    OMNIORB_ROOT=`cd ${OMNIORB_ROOT}/..; pwd`
    if test -d "${OMNIORB_ROOT}/include/omniORB4" ; then
      OMNIORB_VERSION=4
    else
      OMNIORB_VERSION=3
    fi
  fi

  if test "x${OMNIORB_ROOT}" != "x/usr" ; then
    OMNIORB_INCLUDES="-I${OMNIORB_ROOT}/include"
  fi

  OMNIORB_INCLUDES="${OMNIORB_INCLUDES} -I${OMNIORB_ROOT}/include/omniORB${OMNIORB_VERSION}"
#  OMNIORB_INCLUDES="${OMNIORB_INCLUDES} -I${OMNIORB_ROOT}/include/COS"

  OMNIORB_CXXFLAGS="-DOMNIORB_VERSION=${OMNIORB_VERSION} -D__linux__ -D_REENTRANT"

  CPPFLAGS="${OMNIORB_CXXFLAGS} ${OMNIORB_INCLUDES}"
  AC_CHECK_HEADER( [CORBA.h], [ omniORB_ok="yes" ], [ omniORB_ok="no" ] )

  AC_SUBST(OMNIORB_INCLUDES)
  AC_SUBST(OMNIORB_CXXFLAGS)
fi


dnl --------------------------------------------------------------------------------
if test "x${omniORB_ok}" = "xyes" ; then
  if test "x${OMNIORB_LIB}" = "x/usr/lib" ; then
    OMNIORB_LDFLAGS=""
    OMNIORB_RFLAGS=""
  else
    OMNIORB_LDFLAGS="-L${OMNIORB_LIB}"
    OMNIORB_RFLAGS="-R${OMNIORB_LIB}"
  fi

  LIBS="${OMNIORB_LDFLAGS} -lomnithread"
  CPPFLAGS="${OMNIORB_CXXFLAGS} ${OMNIORB_INCLUDES}"

  AC_MSG_CHECKING(linking to omnithreads)
  AC_LINK_IFELSE( AC_LANG_PROGRAM( [ #include <omnithread.h> ], [ omni_mutex my_mutex ] ),
                  [ omniORB_ok=yes ],
                  [ omniORB_ok=no ] )
  AC_MSG_RESULT( ${omniORB_ok} )
fi

  
dnl --------------------------------------------------------------------------------
if test "x${omniORB_ok}" = "xyes" ; then
  OMNIORB_LIBS="${OMNIORB_LDFLAGS}"
  OMNIORB_LIBS="${OMNIORB_LIBS} -lomniORB${OMNIORB_VERSION}"
  OMNIORB_LIBS="${OMNIORB_LIBS} -lomniDynamic${OMNIORB_VERSION}"
#  OMNIORB_LIBS="${OMNIORB_LIBS} -lCOS${OMNIORB_VERSION}"
#  OMNIORB_LIBS="${OMNIORB_LIBS} -lCOSDynamic${OMNIORB_VERSION}"
  OMNIORB_LIBS="${OMNIORB_LIBS} -lomnithread"
#  OMNIORB_LIBS="${OMNIORB_LIBS} ${OMNIORB_RFLAGS}"

  if test ${OMNIORB_VERSION} = 3 ; then
    OMNIORB_LIBS="${OMNIORB_LIBS} -ltcpwrapGK"
  fi

  CPPFLAGS="${OMNIORB_CXXFLAGS} ${OMNIORB_INCLUDES}"
  LIBS="${OMNIORB_LIBS}"

  AC_MSG_CHECKING(linking to omniORB)
  AC_LINK_IFELSE( AC_LANG_PROGRAM( [ #include <CORBA.h> ], [ CORBA::ORB_var orb ] ),
                  [ omniORB_ok=yes ],
                  [ omniORB_ok=no ] )
  AC_MSG_RESULT( ${omniORB_ok} )

  AC_SUBST(OMNIORB_LIBS)
fi

  
dnl --------------------------------------------------------------------------------
if test "x${omniORB_ok}" = "xyes" ; then
  OMNIORB_IDLCXXFLAGS="-nf -I${OMNIORB_ROOT}/idl"
  OMNIORB_IDLPYFLAGS="-bpython -I${OMNIORB_ROOT}/idl"
  AC_SUBST(OMNIORB_IDLCXXFLAGS)
  AC_SUBST(OMNIORB_IDLPYFLAGS)

  OMNIORB_IDL_CLN_H=".hh"
  OMNIORB_IDL_CLN_CXX="SK.cc"
  OMNIORB_IDL_CLN_OBJ="SK.o"
  AC_SUBST(OMNIORB_IDL_CLN_H)
  AC_SUBST(OMNIORB_IDL_CLN_CXX)
  AC_SUBST(OMNIORB_IDL_CLN_OBJ)

  OMNIORB_IDL_SRV_H=".hh"
  OMNIORB_IDL_SRV_CXX="SK.cc"
  OMNIORB_IDL_SRV_OBJ="SK.o"
  AC_SUBST(OMNIORB_IDL_SRV_H)
  AC_SUBST(OMNIORB_IDL_SRV_CXX)
  AC_SUBST(OMNIORB_IDL_SRV_OBJ)

  OMNIORB_IDL_TIE_H=""
  OMNIORB_IDL_TIE_CXX=""
  AC_SUBST(OMNIORB_IDL_TIE_H)
  AC_SUBST(OMNIORB_IDL_TIE_CXX)
fi


dnl --------------------------------------------------------------------------------
AC_REQUIRE([CONFFOAM_CHECK_PYTHON])

omniORBpy_ok=no

if  test "x${omniORB_ok}" = "xyes" ; then
  AC_MSG_CHECKING(omniORBpy)
  `python -c "import omniORB" &> /dev/null`
  if test $? = 0 ; then
    AC_MSG_RESULT(yes)
    omniORBpy_ok=yes
  else
    AC_MSG_RESULT(no, check your installation of omniORBpy)
    omniORBpy_ok=no
  fi
fi


dnl --------------------------------------------------------------------------------
IDL=${OMNIORB_IDL}
IDLGENFLAGS="-bcxx "
AC_SUBST(IDL)	
AC_SUBST(IDLGENFLAGS)	


dnl --------------------------------------------------------------------------------
ENABLE_OMNIORB=${omniORB_ok}
AC_SUBST(ENABLE_OMNIORB)

ENABLE_OMNIORBPY=${omniORBpy_ok}
AC_SUBST(ENABLE_OMNIORBPY)


dnl --------------------------------------------------------------------------------
AC_MSG_RESULT(for omniORBpy: ${omniORBpy_ok})
AC_MSG_RESULT(for omniORB: ${omniORB_ok})


dnl --------------------------------------------------------------------------------
AC_LANG_RESTORE
])


dnl --------------------------------------------------------------------------------

