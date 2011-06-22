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
AC_DEFUN([CONFFOAM_CHECK_OPENFOAM],dnl
[
AC_CHECKING(for OpenFOAM library)

FOAM_VERSION=""
DEV_BRANCH=""
FOAM_PACKAGE_NAME=""
FOAM_PACKAGE_SUFFIX=""
FOAM_PACKAGE_BUILD=""
TEST_CASES=""
HEADER_PATHS=""
LIST_VERSIONS=""

AC_SUBST(FOAM_VERSION)

AC_SUBST(FOAM_BRANCH)

AC_SUBST(ENABLE_OPENFOAM)

AC_SUBST(FOAM_PACKAGE_NAME)

AC_SUBST(FOAM_PACKAGE_SUFFIX)

AC_SUBST(FOAM_PACKAGE_BUILD)

AC_SUBST(TEST_CASES)

AC_SUBST(HEADER_PATHS)

AC_SUBST(LIST_VERSIONS)

openfoam_ok=no


dnl --------------------------------------------------------------------------------
if test -d "${WM_PROJECT_DIR}" ; then
   dnl Look for OpenCFD or Extended OpenFOAM
   FOAM_BRANCH=[`echo ${WM_PROJECT_VERSION} | grep "-" | sed -e "s/\([^-]*\)-\(.*\)/\2/g"`]
   project_version=[`echo ${WM_PROJECT_VERSION} | sed -e "s/-${FOAM_BRANCH}//g" | sed -e "s/[A-Za-z]/0/g"`]
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
else
   dnl Look for FreeFOAM
   if test "${FF_INSTALL_PREFIX}x" = "x" ; then
      FF_INSTALL_PREFIX="/usr/local"
   fi
   AC_MSG_NOTICE( FF_INSTALL_PREFIX == "${FF_INSTALL_PREFIX}" )

   FF_PROJECT_NAME=[`ls ${FF_INSTALL_PREFIX}/include | grep -E "freefoam|FreeFOAM"`]
   AC_MSG_NOTICE( FF_PROJECT_NAME == "${FF_PROJECT_NAME}" )

   if test "${FF_INSTALL_HEADER_PATH}x" = "x" ; then
      FF_INSTALL_HEADER_PATH=${FF_INSTALL_PREFIX}/include/${FF_PROJECT_NAME}
   fi 
   AC_MSG_NOTICE( FF_INSTALL_HEADER_PATH == "${FF_INSTALL_HEADER_PATH}" )

   if test "${FF_INSTALL_LIB_PATH}x" = "x" ; then
      FF_INSTALL_LIB_PATH=${FF_INSTALL_PREFIX}/lib/${FF_PROJECT_NAME}
   fi 
   AC_MSG_NOTICE( FF_INSTALL_LIB_PATH == "${FF_INSTALL_LIB_PATH}" )

   if test "${FF_PROJECT_NAME}x" != "x" -a -d "${FF_INSTALL_HEADER_PATH}"; then
      FOAM_BRANCH="free"
      dnl ${FOAM_VERSION} should be exracted from the FreeFOAM somehow
      FOAM_VERSION=010500 
   fi
fi
AC_MSG_NOTICE( @FOAM_VERSION@ == "${FOAM_VERSION}" )
AC_MSG_NOTICE( @FOAM_BRANCH@ == "${FOAM_BRANCH}" )


dnl --------------------------------------------------------------------------------
if test -z "${FOAM_BRANCH}" -a -z "${FOAM_VERSION}" ; then
   AC_MSG_ERROR([it is neceesary to source an OpenFOAM environment first])
else
   openfoam_ok=yes
fi


dnl --------------------------------------------------------------------------------
ENABLE_OPENFOAM=${openfoam_ok}
AC_MSG_NOTICE( @ENABLE_OPENFOAM@ == "${ENABLE_OPENFOAM}" )


dnl --------------------------------------------------------------------------------
case "x${FOAM_BRANCH}" in
"xfree" )
   case "x${FOAM_VERSION}" in
   "x010500" )
       FOAM_PACKAGE_NAME="freefoam-0.1.0" ;;
   * )
       FOAM_PACKAGE_NAME="freefoam-2.0.0" ;;
   esac
   FOAM_PACKAGE_SUFFIX=[`echo ${FOAM_PACKAGE_NAME} | sed 's/freefoam//'`] ;;
* )
   case "x${WM_PROJECT_VERSION}" in
   "x1.5-dev" )
   	FOAM_PACKAGE_NAME="openfoam-dev-1.5" ;;
   "x1.6-ext" )
	FOAM_PACKAGE_NAME="openfoam-1.6-ext" ;;
   "x1.7.0" )
	FOAM_PACKAGE_NAME="openfoam170" ;;
   "x1.7.1" )
	FOAM_PACKAGE_NAME="openfoam171" ;;
   esac
   FOAM_PACKAGE_SUFFIX=[`echo ${FOAM_PACKAGE_NAME} | sed 's/openfoam//'`] ;;
esac
FOAM_PACKAGE_BUILD=[`dpkg -s ${FOAM_PACKAGE_NAME} 2>/dev/null  | grep Version | sed 's/Version://' `]

AC_MSG_NOTICE( @FOAM_PACKAGE_NAME@ == "${FOAM_PACKAGE_NAME}" )
AC_MSG_NOTICE( @FOAM_PACKAGE_SUFFIX@ == "${FOAM_PACKAGE_SUFFIX}" )
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

AC_MSG_NOTICE( @LIST_VERSIONS@ == "${LIST_VERSIONS}" )
AC_MSG_NOTICE( @HEADER_PATHS@ == "${HEADER_PATHS}" )
AC_MSG_NOTICE( @TEST_CASES@ == "${TEST_CASES}" )


dnl --------------------------------------------------------------------------------
case "x${FOAM_BRANCH}" in
"xfree" )
   OPENFOAM_CPPFLAGS="-I${FF_INSTALL_HEADER_PATH} -I${FF_INSTALL_HEADER_PATH}/OpenFOAM"
   OPENFOAM_CPPFLAGS="${OPENFOAM_CPPFLAGS} -I${FF_INSTALL_HEADER_PATH}/OSspecific"
   OPENFOAM_GFLAGS="-DOpenFOAM_EXPORTS -DDP -DNoRepository -Dlinux64"
   OPENFOAM_CXXFLAGS="${OPENFOAM_GFLAGS} -fPIC -ggdb3 -DFULLDEBUG"
   OPENFOAM_LINKLIBSO="c++ -shared" 
   OPENFOAM_LDFLAGS=-L${FF_INSTALL_LIB_PATH}
   OPENFOAM_LIBS="-lOpenFOAM -lmpiPstream"
   ;;
* )
   dnl --------------------------------------------------------------------------------
cat > conf.include.makefile << 'END'
GENERAL_RULES = $(WM_DIR)/rules/General
RULES         = $(WM_DIR)/rules/$(WM_ARCH)$(WM_COMPILER)
BIN           = $(WM_DIR)/bin/$(WM_ARCH)$(WM_COMPILER)

include $(GENERAL_RULES)/general
include $(RULES)/general
include $(RULES)/$(WM_LINK_LANGUAGE)

c++FLAGS:=$(shell echo $(c++FLAGS) | sed -e"s%-Wold-style-cast %%g")
c++FLAGS:=$(shell echo $(c++FLAGS) | sed -e"s%-Wall %%g")
c++FLAGS:=$(shell echo $(c++FLAGS) | sed -e"s%-Wextra %%g")
# c++FLAGS:=$(shell echo $(c++FLAGS) | sed -e"s%-O3 %-ggdb3 -DFULLDEBUG %g")
END

   dnl --------------------------------------------------------------------------------
cat > conf.cxxflags.makefile << 'END'
include conf.include.makefile
all:
	@echo $(c++FLAGS)
END
   OPENFOAM_CXXFLAGS=`make --makefile=conf.cxxflags.makefile`
   rm -fr conf.cxxflags.makefile

   dnl --------------------------------------------------------------------------------
cat > conf.gflags.makefile << 'END'
include conf.include.makefile
all:
	@echo $(GFLAGS)
END
   OPENFOAM_GFLAGS=`make --makefile=conf.gflags.makefile`
   rm -fr conf.gflags.makefile

   dnl --------------------------------------------------------------------------------
cat > conf.linklibso.makefile << 'END'
include conf.include.makefile
all:
	@echo $(LINKLIBSO)
END
   OPENFOAM_LINKLIBSO=`make --makefile=conf.linklibso.makefile`
   rm -fr conf.linklibso.makefile

   dnl --------------------------------------------------------------------------------
   LIB_SRC=${WM_PROJECT_DIR}/src
   LIB_DIR=${WM_PROJECT_DIR}/lib
   LIB_WM_OPTIONS_DIR=${LIB_DIR}/${WM_OPTIONS}
   LIB_WM_OPTIONS_DIR_BINARY_INSTALL=${LIB_DIR}

   PROJECT_INC="-I${LIB_SRC}/${WM_PROJECT}/lnInclude -I${LIB_SRC}"
   if test ${FOAM_VERSION} -eq 010500 ; then
      PROJECT_INC="${PROJECT_INC} -I${LIB_SRC}/OSspecific/${WM_OS}/lnInclude"
   fi
   if test ${FOAM_VERSION} -ge 010600 ; then
      PROJECT_INC="${PROJECT_INC} -I${LIB_SRC}/OSspecific/${WM_OSTYPE}/lnInclude"
   fi
   OPENFOAM_CPPFLAGS=${PROJECT_INC}

   dnl --------------------------------------------------------------------------------
   OPENFOAM_LDFLAGS="-L${LIB_WM_OPTIONS_DIR} -L${LIB_WM_OPTIONS_DIR_BINARY_INSTALL}"

   dnl --------------------------------------------------------------------------------
   PROJECT_LIBS=-l${WM_PROJECT}
   OPENFOAM_LIBS=${PROJECT_LIBS}

   OPENFOAM_MESHTOOLS_LIBS="-lmeshTools"
   OPENFOAM_MESHTOOLS_CPPFLAGS="-I${LIB_SRC}/meshTools/lnInclude"

   OPENFOAM_BASICTHERMOPHYSICALMODELS_LIBS="-lbasicThermophysicalModels"
   OPENFOAM_BASICTHERMOPHYSICALMODELS_CPPFLAGS="-I${LIB_SRC}/thermophysicalModels/basic/lnInclude"

   OPENFOAM_SPECIE_LIBS="-lspecie"
   OPENFOAM_SPECIE_CPPFLAGS=""

   OPENFOAM_FINITEVOLUME_LIBS="-lfiniteVolume"
   OPENFOAM_FINITEVOLUME_CPPFLAGS="-I${LIB_SRC}/finiteVolume/lnInclude"

   OPENFOAM_SAMPLING_LIBS="-lsampling"
   OPENFOAM_SAMPLING_CPPFLAGS="-I${LIB_SRC}/sampling/lnInclude"

   OPENFOAM_DYNAMICMESH_LIBS="-ldynamicMesh"
   OPENFOAM_DYNAMICMESH_CPPFLAGS="-I${LIB_SRC}/dynamicMesh/lnInclude"
   if test "x${FOAM_BRANCH}" == "xdev" -a ${FOAM_VERSION} -ge 010600 ; then
      OPENFOAM_DYNAMICMESH_CPPFLAGS="${OPENFOAM_DYNAMICMESH_CPPFLAGS} -I${LIB_SRC}/dynamicMesh/dynamicMesh/lnInclude"
   fi

   OPENFOAM_DYNAMICFVMESH_LIBS="-ldynamicFvMesh"
   OPENFOAM_DYNAMICFVMESH_CPPFLAGS="-I${LIB_SRC}/dynamicFvMesh/lnInclude"
   if test "x${FOAM_BRANCH}" == "xdev" -a ${FOAM_VERSION} -ge 010600 ; then
      OPENFOAM_DYNAMICFVMESH_CPPFLAGS="${OPENFOAM_DYNAMICFVMESH_CPPFLAGS} -I${LIB_SRC}/dynamicMesh/dynamicFvMesh/lnInclude"
   fi

   OPENFOAM_RANDOMPROCESS_LIBS="-lrandomProcesses"
   OPENFOAM_RANDOMPROCESS_CPPFLAGS="-I${LIB_SRC}/randomProcesses/lnInclude"

   OPENFOAM_TRANSPORTMODELS_LIBS=""
   OPENFOAM_TRANSPORTMODELS_CPPFLAGS="-I${LIB_SRC}/transportModels"

   OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_LIBS="-lincompressibleTransportModels"
   OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_CPPFLAGS="-I${LIB_SRC}/transportModels/incompressible/lnInclude"

   OPENFOAM_INTERFACEPROPERTIES_LIBS="-linterfaceProperties"
   if test ${FOAM_VERSION} -ge 010701 ; then
      OPENFOAM_INTERFACEPROPERTIES_LIBS="${OPENFOAM_INTERFACEPROPERTIES_LIBS} -ltwoPhaseInterfaceProperties"
   fi
   OPENFOAM_INTERFACEPROPERTIES_CPPFLAGS="-I${LIB_SRC}/transportModels/interfaceProperties/lnInclude"


   rm -fr conf.include.makefile
;;
esac


dnl --------------------------------------------------------------------------------
OPENFOAM_CPPFLAGS="${OPENFOAM_CPPFLAGS} -D__FOAM_VERSION__=${FOAM_VERSION}"
if test "${FOAM_BRANCH}x" != "x" ; then
   OPENFOAM_CPPFLAGS="${OPENFOAM_CPPFLAGS} -D__FOAM_BRANCH__=${FOAM_BRANCH}"
fi

AC_MSG_NOTICE( @OPENFOAM_GFLAGS@ == "${OPENFOAM_GFLAGS}" )
AC_SUBST(OPENFOAM_GFLAGS)

AC_MSG_NOTICE( @OPENFOAM_CPPFLAGS@ == "${OPENFOAM_CPPFLAGS}" )
AC_SUBST(OPENFOAM_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_CXXFLAGS@ == "${OPENFOAM_CXXFLAGS}" )
AC_SUBST(OPENFOAM_CXXFLAGS)

AC_MSG_NOTICE( @OPENFOAM_LINKLIBSO@ == "${OPENFOAM_LINKLIBSO}" )
AC_SUBST(OPENFOAM_LINKLIBSO)

AC_MSG_NOTICE( @OPENFOAM_LDFLAGS@ == "${OPENFOAM_LDFLAGS}" )
AC_SUBST(OPENFOAM_LDFLAGS)

AC_MSG_NOTICE( @OPENFOAM_LIBS@ == "${OPENFOAM_LIBS}" )
AC_SUBST(OPENFOAM_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_MESHTOOLS_CPPFLAGS@ == "${OPENFOAM_MESHTOOLS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_MESHTOOLS_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_MESHTOOLS_LIBS@ == "${OPENFOAM_MESHTOOLS_LIBS}" )
AC_SUBST(OPENFOAM_MESHTOOLS_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_BASICTHERMOPHYSICALMODELS_CPPFLAGS@ == "${OPENFOAM_BASICTHERMOPHYSICALMODELS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_BASICTHERMOPHYSICALMODELS_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_BASICTHERMOPHYSICALMODELS_LIBS@ == "${OPENFOAM_BASICTHERMOPHYSICALMODELS_LIBS}" )
AC_SUBST(OPENFOAM_BASICTHERMOPHYSICALMODELS_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_SPECIE_CPPFLAGS@ == "${OPENFOAM_SPECIE_CPPFLAGS}" )
AC_SUBST(OPENFOAM_SPECIE_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_SPECIE_LIBS@ == "${OPENFOAM_SPECIE_LIBS}" )
AC_SUBST(OPENFOAM_SPECIE_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_FINITEVOLUME_CPPFLAGS@ == "${OPENFOAM_FINITEVOLUME_CPPFLAGS}" )
AC_SUBST(OPENFOAM_FINITEVOLUME_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_FINITEVOLUME_LIBS@ == "${OPENFOAM_FINITEVOLUME_LIBS}" )
AC_SUBST(OPENFOAM_FINITEVOLUME_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_SAMPLING_CPPFLAGS@ == "${OPENFOAM_SAMPLING_CPPFLAGS}" )
AC_SUBST(OPENFOAM_SAMPLING_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_SAMPLING_LIBS@ == "${OPENFOAM_SAMPLING_LIBS}" )
AC_SUBST(OPENFOAM_SAMPLING_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_DYNAMICMESH_CPPFLAGS@ == "${OPENFOAM_DYNAMICMESH_CPPFLAGS}" )
AC_SUBST(OPENFOAM_DYNAMICMESH_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_DYNAMICMESH_LIBS@ == "${OPENFOAM_DYNAMICMESH_LIBS}" )
AC_SUBST(OPENFOAM_DYNAMICMESH_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_DYNAMICFVMESH_CPPFLAGS@ == "${OPENFOAM_DYNAMICFVMESH_CPPFLAGS}" )
AC_SUBST(OPENFOAM_DYNAMICFVMESH_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_DYNAMICFVMESH_LIBS@ == "${OPENFOAM_DYNAMICFVMESH_LIBS}" )
AC_SUBST(OPENFOAM_DYNAMICFVMESH_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_RANDOMPROCESS_CPPFLAGS@ == "${OPENFOAM_RANDOMPROCESS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_RANDOMPROCESS_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_RANDOMPROCESS_LIBS@ == "${OPENFOAM_RANDOMPROCESS_LIBS}" )
AC_SUBST(OPENFOAM_RANDOMPROCESS_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_TRANSPORTMODELS_CPPFLAGS@ == "${OPENFOAM_TRANSPORTMODELS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_TRANSPORTMODELS_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_TRANSPORTMODELS_LIBS@ == "${OPENFOAM_TRANSPORTMODELS_LIBS}" )
AC_SUBST(OPENFOAM_TRANSPORTMODELS_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_CPPFLAGS@ == "${OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_LIBS@ == "${OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_LIBS}" )
AC_SUBST(OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_INTERFACEPROPERTIES_CPPFLAGS@ == "${OPENFOAM_INTERFACEPROPERTIES_CPPFLAGS}" )
AC_SUBST(OPENFOAM_INTERFACEPROPERTIES_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_INTERFACEPROPERTIES_LIBS@ == "${OPENFOAM_INTERFACEPROPERTIES_LIBS}" )
AC_SUBST(OPENFOAM_INTERFACEPROPERTIES_LIBS)


dnl --------------------------------------------------------------------------------
])


dnl --------------------------------------------------------------------------------

