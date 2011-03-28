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
AC_DEFUN([CONFFOAM_CHECK_OS],
[
  AC_MSG_NOTICE(calculating OS parameters)
  OS_CODENAME=""
  OS_ARCHITECTURE=""
  SUSE_VERSION=""
  
  AC_SUBST(OS_CODENAME)
  
  AC_SUBST(OS_ARCHITECTURE)
  
  AC_SUBST(SUSE_VERSION)
  
  os_suse=[`lsb_release -a 2>/dev/null | grep "openSUSE"`]

  if test "x${os_suse}" == "x"; then
     os="UBUNTU"
  else
     os="openSUSE"
  fi

  if test "${os}" == "UBUNTU"; then
     OS_CODENAME=[`lsb_release -a 2>/dev/null | grep Codename | sed 's/Codename:\t//'`]
     OS_ARCHITECTURE=[`dpkg --print-architecture`]
     AC_MSG_NOTICE( @OS_CODENAME@ == "${OS_CODENAME}" )
  fi
  
  if test "${os}" == "openSUSE"; then
     SUSE_VERSION=[`lsb_release -a 2>/dev/null | grep Release | sed 's/Release:\t//'`]
     OS_ARCHITECTURE=[`lsb_release -a 2>/dev/null | grep Description | sed 's/Description:\t//' | awk -F" " '{print $3}' | sed 's/^(//' | sed 's/)//'`]
     AC_MSG_NOTICE( @SUSE_VERSION@ == "${SUSE_VERSION}" )
  fi
  
  AC_MSG_NOTICE( @OS_ARCHITECTURE@ == "${OS_ARCHITECTURE}" )
  
])


dnl --------------------------------------------------------------------------------

