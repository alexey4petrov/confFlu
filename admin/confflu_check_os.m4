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
AC_DEFUN([CONFFLU_CHECK_OS],
[
  AC_MSG_NOTICE(calculating OS parameters)
  
  OS_NAME=""
  UBUNTU_CODENAME=""
  OS_ARCHITECTURE=""
  SUSE_VERSION=""
  
  AC_SUBST(OS_NAME)
  
  AC_SUBST(UBUNTU_CODENAME)
  
  AC_SUBST(OS_ARCHITECTURE)
  
  AC_SUBST(SUSE_VERSION)
  
  os_suse=[`cat /etc/*-release | grep "openSUSE"`]
  
  os_ubuntu=[`cat /etc/*-release | grep "Ubuntu"`]

  OS_NAME=[`uname -s`]

  if test "x${os_suse}" != "x"; then
     OS_NAME="openSUSE"
  fi
  
  if test "x${os_ubuntu}" != "x"; then
     OS_NAME="Ubuntu"
  fi

  AC_MSG_NOTICE( @OS_NAME@ == "${OS_NAME}" )
  
  if test "${OS_NAME}" == "Ubuntu"; then
     UBUNTU_CODENAME=[`cat /etc/*-release | grep DISTRIB_CODENAME | sed 's/DISTRIB_CODENAME=//'`]
     OS_ARCHITECTURE=[`dpkg --print-architecture`]
     AC_MSG_NOTICE( @UBUNTU_CODENAME@ == "${UBUNTU_CODENAME}" )
  fi
  
  if test "${OS_NAME}" == "openSUSE"; then
     SUSE_VERSION=[`cat /etc/*-release | grep VERSION | sed 's/VERSION = //'`]
     string=[`cat /etc/*-release | grep "openSUSE ${SUSE_VERSION}"`]
     OS_ARCHITECTURE=[`echo ${string} | sed "s/openSUSE ${SUSE_VERSION} (//" | sed 's/)//'`]
     AC_MSG_NOTICE( @SUSE_VERSION@ == "${SUSE_VERSION}" )
  fi
  
  AC_MSG_NOTICE( @OS_ARCHITECTURE@ == "${OS_ARCHITECTURE}" )
  
  OS_UNAME=[`uname -s `]
  
  LIB_EXTENSION="so"
  GNU_LDFLAGS="-Xlinker --add-needed -Xlinker --no-as-needed"
  LDCONFIG=ldconfig
  FIND=find
  
  if test "x${OS_UNAME}" == "xDarwin"; then
     GNU_LDFLAGS=
     LIB_EXTENSION="dylib"
     LDCONFIG=
     FIND=gfind

     alias wc=gwc
     alias tail=gtail
  fi
  
  AC_SUBST(FIND)
  AC_SUBST(LDCONFIG)
])


dnl --------------------------------------------------------------------------------

