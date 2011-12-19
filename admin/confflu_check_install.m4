dnl managedFlu - OpenFOAM C++ interactive functionality API
dnl Copyright (C) 2011- Alexey Petrov
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
dnl See http://sourceforge.net/projects/managedflu
dnl
dnl Author : Alexey PETROV, Andrey SIMURZIN
dnl


dnl --------------------------------------------------------------------------------
AC_DEFUN([CONFFLU_CHECK_INSTALL],
[
AC_CHECKING(for package installation procedure)

AC_REQUIRE([CONFFLU_CHECK_OPENFOAM])
AC_REQUIRE([CONFFLU_CHECK_PYTHON])
AC_REQUIRE([CONFFLU_CHECK_PROJECT_VERSION1])

PACKAGE_INSTALL_DIR=""
PACKAGE_INSTALL_BIN_DIR=""
PACKAGE_INSTALL_LIB_DIR=""
PACKAGE_INSTALL_INCLUDE_DIR=""
PACKAGE_INSTALL_M4_DIR=""

AC_SUBST(PACKAGE_INSTALL_DIR)

AC_SUBST(PACKAGE_INSTALL_BIN_DIR)

AC_SUBST(PACKAGE_INSTALL_LIB_DIR)

AC_SUBST(PACKAGE_INSTALL_INCLUDE_DIR)

AC_SUBST(PACKAGE_INSTALL_M4_DIR)

if test "${prefix}" = "NONE"; then
  package_prefix=
else
  package_prefix=${prefix}
fi

case "x${FOAM_BRANCH}" in
"xfree" )
   PACKAGE_INSTALL_DIR="${package_prefix}/usr/local"
   PACKAGE_INSTALL_BIN_DIR="${PACKAGE_INSTALL_DIR}/bin"
   PACKAGE_INSTALL_LIB_DIR="${PACKAGE_INSTALL_DIR}/lib"
   PACKAGE_INSTALL_INCLUDE_DIR="${PACKAGE_INSTALL_DIR}/include/${PACKAGE_TARNAME}${FOAM_PACKAGE_SUFFIX}-${PACKAGE_VERSION}-${BUILD_VERSION}"
   PACKAGE_INSTALL_M4_DIR="${PACKAGE_INSTALL_DIR}/share/${PACKAGE_TARNAME}${FOAM_PACKAGE_SUFFIX}-${PACKAGE_VERSION}-${BUILD_VERSION}"
;;
* )
   FOAM_FOLDER=`dirname ${FOAM_PACKAGE_DIR}`
   PACKAGE_INSTALL_DIR="${package_prefix}${FOAM_FOLDER}/${PACKAGE_TARNAME}${FOAM_PACKAGE_SUFFIX}-${PACKAGE_VERSION}-${BUILD_VERSION}"
   PACKAGE_INSTALL_BIN_DIR="${PACKAGE_INSTALL_DIR}/bin"
   PACKAGE_INSTALL_LIB_DIR="${PACKAGE_INSTALL_DIR}/lib"
   PACKAGE_INSTALL_M4_DIR="${PACKAGE_INSTALL_DIR}"
   PACKAGE_INSTALL_INCLUDE_DIR="${PACKAGE_INSTALL_DIR}/src"
;;
esac

AC_MSG_NOTICE( @PACKAGE_INSTALL_DIR@ == "${PACKAGE_INSTALL_DIR}" )

AC_MSG_NOTICE( @PACKAGE_INSTALL_BIN_DIR@ == "${PACKAGE_INSTALL_BIN_DIR}" )

AC_MSG_NOTICE( @PACKAGE_INSTALL_LIB_DIR@ == "${PACKAGE_INSTALL_LIB_DIR}" )

AC_MSG_NOTICE( @PACKAGE_INSTALL_INCLUDE_DIR@ == "${PACKAGE_INSTALL_INCLUDE_DIR}" )

AC_MSG_NOTICE( @PACKAGE_INSTALL_M4_DIR@ == "${PACKAGE_INSTALL_M4_DIR}" )

AC_MSG_NOTICE( @PACKAGE_INSTALL_PYTHON_DIR@ == "${PACKAGE_INSTALL_PYTHON_DIR}" )

])


dnl --------------------------------------------------------------------------------
