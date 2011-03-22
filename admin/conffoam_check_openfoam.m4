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
AC_DEFUN([CONFFOAM_CHECK_OPENFOAM],dnl
[
AC_CHECKING(for OpenFOAM library)

FOAM_VERSION=""
DEV_BRANCH=""
FOAM_PACKAGE_NAME=""
FOAM_PACKAGE_BUILD=""
TEST_CASES=""
HEADER_PATHS=""
LIST_VERSIONS=""

AC_SUBST(FOAM_VERSION)

AC_SUBST(FOAM_BRANCH)

AC_SUBST(ENABLE_OPENFOAM)

AC_SUBST(FOAM_PACKAGE_NAME)

AC_SUBST(FOAM_PACKAGE_BUILD)

AC_SUBST(TEST_CASES)

AC_SUBST(HEADER_PATHS)

AC_SUBST(LIST_VERSIONS)



openfoam_ok=no


dnl --------------------------------------------------------------------------------
AC_MSG_CHECKING(location of the OpenFOAM installation)
if test -d "${WM_PROJECT_DIR}" ; then
   openfoam_ok=yes
fi
AC_MSG_RESULT(${openfoam_ok})


dnl --------------------------------------------------------------------------------
if test "x${openfoam_ok}" = "xyes" ; then
   project_version=[`echo ${WM_PROJECT_VERSION} | sed  -e"s%\([0-9\.]\+\)-[a-z]*%\1%g"`]
   FOAM_BRANCH=[`echo ${WM_PROJECT_VERSION} | sed -e "s/[0-9,.,-]//g"`]
   number_counter=[`echo ${project_version} | sed -e"s%[^\.]%%g" | wc --bytes`]

   if test "x${number_counter}" = "x2" ; then
      FOAM_VERSION=[`echo ${project_version} | sed -e"s%^\([1-9]\)\.\([0-9]\).*%0\10\200%g"`]
   fi

   if test "x${number_counter}" = "x3" ; then
      FOAM_VERSION=[`echo ${project_version} | sed -e"s%^\([1-9]\)\.\([0-9]\)\.\([0-9]\).*%0\10\20\3%g"`]
   fi
   
   if test "x${FOAM_BRANCH}" == "xext" ; then
      FOAM_BRANCH="dev"
   fi
   AC_MSG_NOTICE( @FOAM_VERSION@ == "${FOAM_VERSION}" )
   AC_MSG_NOTICE( @FOAM_BRANCH@ == "${FOAM_BRANCH}" )
fi


dnl --------------------------------------------------------------------------------
if test "x${openfoam_ok}" = "xno" ; then
   AC_MSG_WARN([it is neceesary to source OpenFOAM environment first])
fi


dnl --------------------------------------------------------------------------------
ENABLE_OPENFOAM=${openfoam_ok}


dnl --------------------------------------------------------------------------------
if test "x${WM_PROJECT_VERSION}" = "x1.5-dev" ; then
   FOAM_PACKAGE_NAME="openfoam-dev-1.5"
fi

if test "x${WM_PROJECT_VERSION}" = "x1.6-ext" ; then
   FOAM_PACKAGE_NAME="openfoam-1.6-ext"
fi

if test "x${WM_PROJECT_VERSION}" = "x1.7.0" ; then
   FOAM_PACKAGE_NAME="openfoam170"
fi

if test "x${WM_PROJECT_VERSION}" = "x1.7.1" ; then
   FOAM_PACKAGE_NAME="openfoam171"
fi

FOAM_PACKAGE_BUILD=[`dpkg -s ${FOAM_PACKAGE_NAME} | grep Version | sed 's/Version://' `]

AC_MSG_NOTICE( @FOAM_PACKAGE_NAME@ == "${FOAM_PACKAGE_NAME}" )
AC_MSG_NOTICE( @FOAM_PACKAGE_BUILD@ == "${FOAM_PACKAGE_BUILD}" )


dnl --------------------------------------------------------------------------------
if test ${FOAM_VERSION} -ge 010701; then
   if test "x${FOAM_BRANCH}" != "x" ; then
      TEST_CASES+="r1.7.1-${FOAM_BRANCH} "
      LIST_VERSIONS+="\"010701_${FOAM_BRANCH}\","
      HEADER_PATHS+="/patches/r1.7.1-${FOAM_BRANCH} "
   else
      HEADER_PATHS+="/patches/r1.7.1 "
      LIST_VERSIONS+="\"010701\","
      TEST_CASES+="r1.7.1 "
   fi
fi

if test ${FOAM_VERSION} -ge 010700; then
   if test "x${FOAM_BRANCH}" != "x"; then
      TEST_CASES+="r1.7.0-${FOAM_BRANCH} "
      LIST_VERSIONS+="\"010700_${FOAM_BRANCH}\","
      HEADER_PATHS+="/patches/r1.7.0-${FOAM_BRANCH} "
   else
      HEADER_PATHS+="/patches/r1.7.0 "
      LIST_VERSIONS+="\"010700\","
      TEST_CASES+="r1.7.0 "
   fi
fi

if test ${FOAM_VERSION} -ge 010600; then
   if test "x${FOAM_BRANCH}" != "x"; then
      TEST_CASES+="r1.6-${FOAM_BRANCH} "
      LIST_VERSIONS+="\"010600_${FOAM_BRANCH}\","
      HEADER_PATHS+="/patches/r1.6-${FOAM_BRANCH} "
   else
      HEADER_PATHS+="/patches/r1.6 "
      LIST_VERSIONS+="\"010600\","
      TEST_CASES+="r1.6 "      
   fi
fi

if test ${FOAM_VERSION} -ge 010500; then
   if test "x${FOAM_BRANCH}" != "x" ; then
      TEST_CASES+="r1.5-${FOAM_BRANCH} "
      LIST_VERSIONS+="\"010500_${FOAM_BRANCH}\","
      HEADER_PATHS+="/patches/r1.5-${FOAM_BRANCH} "
   else
      HEADER_PATHS+="/patches/r1.5 "
      LIST_VERSIONS+="\"010500\","
      TEST_CASES+="r1.5 "
   fi
fi

TEST_CASES+="r1.4.1-dev"
LIST_VERSIONS+=\"010401_dev\"
HEADER_PATHS+="/patches/r1.4.1-dev "
])


dnl --------------------------------------------------------------------------------

