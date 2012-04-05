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
AC_DEFUN([CONFFLU_CHECK_OPENFOAM],dnl
[
AC_CHECKING(for OpenFOAM library)
AC_REQUIRE([CONFFLU_CHECK_OS])

FOAM_VERSION=""
DEV_BRANCH=""
FOAM_PACKAGE_NAME=""
FOAM_PACKAGE_SUFFIX=""
FOAM_PACKAGE_BUILD=""
FOAM_PACKAGE_DIR=""
TEST_CASES=""
HEADER_PATHS=""
LIST_VERSIONS=""
DEFINE_FOAM_BRANCH=""
DEFINE_FOAM_VERSION=""
FOAM_USER_BIN=""
FOAM_USER_LIB=""

AC_SUBST(FOAM_VERSION)

AC_SUBST(FOAM_BRANCH)

AC_SUBST(ENABLE_OPENFOAM)

AC_SUBST(FOAM_PACKAGE_NAME)

AC_SUBST(FOAM_PACKAGE_SUFFIX)

AC_SUBST(FOAM_PACKAGE_BUILD)

AC_SUBST(FOAM_PACKAGE_DIR)

AC_SUBST(TEST_CASES)

AC_SUBST(HEADER_PATHS)

AC_SUBST(LIST_VERSIONS)

AC_SUBST(DEFINE_FOAM_BRANCH)

AC_SUBST(DEFINE_FOAM_VERSION)

AC_SUBST(FOAM_USER_BIN)

AC_SUBST(FOAM_USER_LIB)

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
   FOAM_PACKAGE_DIR=$WM_PROJECT_DIR
else
   dnl Look for FreeFOAM
   dnl --------------------------------------------------------------------------------
cat > CMakeLists.txt << 'END'
cmake_minimum_required(VERSION 2.8)
find_package(FreeFOAM REQUIRED)
message( ${FOAM_INCLUDE_DIRS} )
END
   FF_INSTALL_HEADER_PATH=`cmake . >/dev/null 2>CMakeOuput.txt && cat CMakeOuput.txt && rm -fr CMake*.*`
   AC_MSG_NOTICE( FF_INSTALL_HEADER_PATH == "${FF_INSTALL_HEADER_PATH}" )
   
   dnl --------------------------------------------------------------------------------
cat > CMakeLists.txt << 'END'
cmake_minimum_required(VERSION 2.8)
find_package(FreeFOAM REQUIRED)
message( ${FOAM_LIBRARY_DIRS} )
END
   FF_INSTALL_LIB_PATH=`cmake . >/dev/null 2>CMakeOuput.txt && cat CMakeOuput.txt && rm -fr CMake*.*`
   AC_MSG_NOTICE( FF_INSTALL_LIB_PATH == "${FF_INSTALL_LIB_PATH}" )

   dnl --------------------------------------------------------------------------------
cat > CMakeLists.txt << 'END'
cmake_minimum_required(VERSION 2.8)
find_package(FreeFOAM REQUIRED)
message( "${FOAM_DEFINITIONS}" )
END
   FF_DEFINITIONS=`cmake . >/dev/null 2>CMakeOuput.txt && cat CMakeOuput.txt && rm -fr CMake*.*`
   FF_DEFINITIONS=`echo ${FF_DEFINITIONS} | sed -e "s%;% %g"`
   AC_MSG_NOTICE( FF_DEFINITIONS == "${FF_DEFINITIONS}" )

   dnl --------------------------------------------------------------------------------
   FF_VERSION_FULL=`python -c "from FreeFOAM import VERSION_FULL; print VERSION_FULL"`
   AC_MSG_NOTICE( FF_VERSION_FULL == "${FF_VERSION_FULL}" )

   dnl --------------------------------------------------------------------------------
   if test "${FF_VERSION_FULL}x" != "x" -a "${FF_DEFINITIONS}x" != "x" ; then
      case ${FF_VERSION_FULL} in
      "0.1.0" )
      	  FOAM_VERSION=010500 ;;
      "0.1.0rc5" )
      	  FOAM_VERSION=010701 ;;
      * )
      	  FOAM_VERSION=010701 ;;
      esac

      FOAM_BRANCH="free"
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
   FOAM_PACKAGE_NAME="freefoam-${FF_VERSION_FULL}"
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
   "x2.0.0" )
	FOAM_PACKAGE_NAME="openfoam200" ;;
   "x2.0.1" )
	FOAM_PACKAGE_NAME="openfoam201" ;;
   "x2.1.0" )
	FOAM_PACKAGE_NAME="openfoam210" ;;
   esac
   FOAM_PACKAGE_SUFFIX=[`echo ${FOAM_PACKAGE_NAME} | sed 's/openfoam//'`] ;;
esac
FOAM_PACKAGE_BUILD=[`dpkg -s ${FOAM_PACKAGE_NAME} 2>/dev/null  | grep Version | sed 's/Version://' `]

AC_MSG_NOTICE( @FOAM_PACKAGE_NAME@ == "${FOAM_PACKAGE_NAME}" )
AC_MSG_NOTICE( @FOAM_PACKAGE_SUFFIX@ == "${FOAM_PACKAGE_SUFFIX}" )
AC_MSG_NOTICE( @FOAM_PACKAGE_BUILD@ == "${FOAM_PACKAGE_BUILD}" )


dnl --------------------------------------------------------------------------------
case "x${FOAM_BRANCH}" in
xfree )
  if test ${FOAM_VERSION} -ge 010701; then
        TEST_CASES+="r1.7.1-${FOAM_BRANCH} "
        LIST_VERSIONS+="\"010701_${FOAM_BRANCH}\","
        HEADER_PATHS+="/patches/r1.7.1-${FOAM_BRANCH} "
  fi
  if test ${FOAM_VERSION} -ge 010500; then
     TEST_CASES+="r1.5-${FOAM_BRANCH} "
     LIST_VERSIONS+="\"010500_${FOAM_BRANCH}\","
     HEADER_PATHS+="/patches/r1.5-${FOAM_BRANCH} "
  fi
;;
xdev )
  if test ${FOAM_VERSION} -ge 010600; then
     TEST_CASES+="r1.6-${FOAM_BRANCH} "
     LIST_VERSIONS+="\"010600_${FOAM_BRANCH}\","
     HEADER_PATHS+="/patches/r1.6-${FOAM_BRANCH} "
  fi

  if test ${FOAM_VERSION} -ge 010500; then
     TEST_CASES+="r1.5-${FOAM_BRANCH} "
     LIST_VERSIONS+="\"010500_${FOAM_BRANCH}\","
     HEADER_PATHS+="/patches/r1.5-${FOAM_BRANCH} "
  fi

  TEST_CASES+="r1.4.1-dev"
  LIST_VERSIONS+=\"010401_dev\"
  HEADER_PATHS+="/patches/r1.4.1-dev "
;;
*)
  if test ${FOAM_VERSION} -ge 020100; then
     HEADER_PATHS+="/patches/r2.1.0 "
     LIST_VERSIONS+="\"020100\","
     TEST_CASES+="r2.1.0 "
  fi

  if test ${FOAM_VERSION} -ge 020001; then
     HEADER_PATHS+="/patches/r2.0.1 "
     LIST_VERSIONS+="\"020001\","
     TEST_CASES+="r2.0.1 "
  fi

  if test ${FOAM_VERSION} -ge 020000; then
     HEADER_PATHS+="/patches/r2.0.0 "
     LIST_VERSIONS+="\"020000\","
     TEST_CASES+="r2.0.0 "
  fi

  if test ${FOAM_VERSION} -ge 010701; then
     HEADER_PATHS+="/patches/r1.7.1 "
     LIST_VERSIONS+="\"010701\","
     TEST_CASES+="r1.7.1 "
  fi

  if test ${FOAM_VERSION} -ge 010700; then
     HEADER_PATHS+="/patches/r1.7.0 "
     LIST_VERSIONS+="\"010700\","
     TEST_CASES+="r1.7.0 "
  fi

  if test ${FOAM_VERSION} -ge 010600; then
     HEADER_PATHS+="/patches/r1.6 "
     LIST_VERSIONS+="\"010600\","
     TEST_CASES+="r1.6 "      
  fi

  if test ${FOAM_VERSION} -ge 010500; then
     HEADER_PATHS+="/patches/r1.5 "
     LIST_VERSIONS+="\"010500\","
     TEST_CASES+="r1.5 "
  fi

  TEST_CASES+="r1.4.1-dev"
  LIST_VERSIONS+=\"010401_dev\"
  HEADER_PATHS+="/patches/r1.4.1-dev "
;;
esac

AC_MSG_NOTICE( @LIST_VERSIONS@ == "${LIST_VERSIONS}" )
AC_MSG_NOTICE( @HEADER_PATHS@ == "${HEADER_PATHS}" )
AC_MSG_NOTICE( @TEST_CASES@ == "${TEST_CASES}" )

FOAM_USER_BIN=${FOAM_USER_APPBIN}
FOAM_USER_LIB=${FOAM_USER_LIBBIN}
AC_MSG_NOTICE( @FOAM_USER_BIN@ == "${FOAM_USER_BIN}" )
AC_MSG_NOTICE( @FOAM_USER_LIB@ == "${FOAM_USER_LIB}" )



dnl --------------------------------------------------------------------------------
case "x${FOAM_BRANCH}" in
"xfree" )
   OPENFOAM_CC=cc
   OPENFOAM_CPPFLAGS="-I${FF_INSTALL_HEADER_PATH} -I${FF_INSTALL_HEADER_PATH}/OpenFOAM"
   OPENFOAM_CPPFLAGS="${OPENFOAM_CPPFLAGS} -I${FF_INSTALL_HEADER_PATH}/OSspecific"

   OPENFOAM_GFLAGS="-DOpenFOAM_EXPORTS ${FF_DEFINITIONS}"

   OPENFOAM_CXXFLAGS="${OPENFOAM_GFLAGS} -fPIC -Wno-unused-parameter"
   # OPENFOAM_CXXFLAGS="${OPENFOAM_CXXFLAGS} -ggdb3 -DFULLDEBUG"

   OPENFOAM_LINKLIBSO="c++ -shared"
   OPENFOAM_LINKEXE="c++"
   
   OPENFOAM_LDFLAGS="-Wl,-rpath=${FF_INSTALL_LIB_PATH}"
   
   FOAM_LIBS_PREFIX="-l"
   FOAM_LIBS_SUFFIX=""
   
   OPENFOAM_LIBS="${FOAM_LIBS_PREFIX}OpenFOAM${FOAM_LIBS_SUFFIX}"
   OPENFOAM_LIBS="${OPENFOAM_LIBS} ${FOAM_LIBS_PREFIX}mpiPstream${FOAM_LIBS_SUFFIX}"
   
   OPENFOAM_LINKLIBSO_LIBS=${OPENFOAM_LIBS}
   OPENFOAM_LINKEXE_LIBS=${OPENFOAM_LIBS}


   OPENFOAM_LDFLAGS="-L${FF_INSTALL_LIB_PATH} -Wl,-rpath=${FF_INSTALL_LIB_PATH}"
   if test ${FOAM_VERSION} -ge 010701 ; then
      OPENFOAM_LDFLAGS="${OPENFOAM_LDFLAGS} -L${FF_INSTALL_LIB_PATH}/plugins1 -Wl,-rpath=${FF_INSTALL_LIB_PATH}/plugins1"
   fi

   OPENFOAM_MESHTOOLS_CPPFLAGS="-I${FF_INSTALL_HEADER_PATH}/meshTools"

   OPENFOAM_BASICTHERMOPHYSICALMODELS_CPPFLAGS="-I${FF_INSTALL_HEADER_PATH}/basicThermophysicalModels"

   OPENFOAM_RADIATION_CPPFLAGS="-I${FF_INSTALL_HEADER_PATH}/radiation"

   OPENFOAM_SPECIE_CPPFLAGS=""

   OPENFOAM_FINITEVOLUME_CPPFLAGS="-I${FF_INSTALL_HEADER_PATH}/finiteVolume"

   OPENFOAM_SAMPLING_CPPFLAGS="-I${FF_INSTALL_HEADER_PATH}/sampling"

   OPENFOAM_DYNAMICMESH_CPPFLAGS="-I${FF_INSTALL_HEADER_PATH}/dynamicMesh"

   OPENFOAM_DYNAMICFVMESH_CPPFLAGS="-I${FF_INSTALL_HEADER_PATH}/dynamicFvMesh"

   OPENFOAM_RANDOMPROCESS_CPPFLAGS="-I${FF_INSTALL_HEADER_PATH}/randomProcesses"

   OPENFOAM_TRANSPORTMODELS_CPPFLAGS=""

   OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_CPPFLAGS="-I${FF_INSTALL_HEADER_PATH}/incompressibleTransportModels"

   OPENFOAM_TURBULENCEMODELS_CPPFLAGS=""

   OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS=""
   OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS="${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS} -I${FF_INSTALL_HEADER_PATH}/incompressibleLESModels"
   OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS="${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS} -I${FF_INSTALL_HEADER_PATH}/incompressibleRASModels"

   if test ${FOAM_VERSION} -ge 010701 ; then
      OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS="${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS} -I${FF_INSTALL_HEADER_PATH}/incompressibleTurbulenceModel"
   fi
   
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS=""
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS} -I${FF_INSTALL_HEADER_PATH}/compressibleLESModels"
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS} -I${FF_INSTALL_HEADER_PATH}/compressibleRASModels"
   if test ${FOAM_VERSION} -ge 010701 ; then
     OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS} -I${FF_INSTALL_HEADER_PATH}/compressibleTurbulenceModel"
   fi
   
   OPENFOAM_INTERFACEPROPERTIES_CPPFLAGS="-I${FF_INSTALL_HEADER_PATH}/interfaceProperties"

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
cat > conf.linkexe.makefile << 'END'
include conf.include.makefile
all:
	@echo $(LINKEXE)
END
   OPENFOAM_LINKEXE=`make --makefile=conf.linkexe.makefile`
   rm -fr conf.linkexe.makefile

   dnl --------------------------------------------------------------------------------
cat > conf.glibs.makefile << 'END'
include conf.include.makefile
all:
	@echo $(GLIBS)
END
   OPENFOAM_GLIBS=`make --makefile=conf.glibs.makefile`
   rm -fr conf.glibs.makefile

   dnl --------------------------------------------------------------------------------
cat > conf.glib_libs.makefile << 'END'
include conf.include.makefile
all:
	@echo $(GLIB_LIBS)
END
   OPENFOAM_GLIB_LIBS=`make --makefile=conf.glib_libs.makefile`
   rm -fr conf.glib_libs.makefile

   dnl --------------------------------------------------------------------------------
cat > conf.projectlibs.makefile << 'END'
include conf.include.makefile
all:
	@echo $(PROJECT_LIBS)
END
   OPENFOAM_PROJECT_LIBS=`make --makefile=conf.projectlibs.makefile`
   rm -fr conf.projectlibs.makefile

   dnl --------------------------------------------------------------------------------
cat > conf.openfoam_cc.makefile << 'END'
include conf.include.makefile
all:
	@echo $(CC)
END
   OPENFOAM_CC=`make --makefile=conf.openfoam_cc.makefile`
   rm -fr conf.openfoam_cc.makefile

   dnl --------------------------------------------------------------------------------

   LIB_SRC=${WM_PROJECT_DIR}/src
   LIB_DIR=${WM_PROJECT_DIR}/lib
   LIB_WM_OPTIONS_DIR=${LIB_DIR}/${WM_OPTIONS}
      
   if test ${FOAM_VERSION} -ge 020000 ; then   
      LIB_DIR=${WM_PROJECT_DIR}/platforms
      LIB_WM_OPTIONS_DIR=${LIB_DIR}/${WM_OPTIONS}/lib
   fi

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
   FOAM_LIBS_PREFIX="-l"
   FOAM_LIBS_SUFFIX=""
   
   
   PROJECT_LIBS=${FOAM_LIBS_PREFIX}${WM_PROJECT}${FOAM_LIBS_SUFFIX}
   OPENFOAM_LIBS=${PROJECT_LIBS}

   OPENFOAM_LINKEXE_LIBS="${OPENFOAM_PROJECT_LIBS} ${OPENFOAM_GLIBS}"
   OPENFOAM_LINKLIBSO_LIBS="${OPENFOAM_LIBS} ${OPENFOAM_GLIB_LIBS}"

   OPENFOAM_MESHTOOLS_CPPFLAGS="-I${LIB_SRC}/meshTools/lnInclude"

   OPENFOAM_BASICTHERMOPHYSICALMODELS_CPPFLAGS="-I${LIB_SRC}/thermophysicalModels/basic/lnInclude"
   
   if test ${FOAM_VERSION} -ge 020000 ; then
     OPENFOAM_BASICSOLIDTHERMO_CPPFLAGS="-I${LIB_SRC}/thermophysicalModels/basicSolidThermo/lnInclude"   
   fi
     
   if test ${FOAM_VERSION} -ge 020000 ; then
     OPENFOAM_THERMALPOROUSZONE_CPPFLAGS="-I${LIB_SRC}/thermophysicalModels/thermalPorousZone/lnInclude"   
   fi

   if test ${FOAM_VERSION} -lt 020000 ; then
     OPENFOAM_RADIATION_CPPFLAGS="-I${LIB_SRC}/thermophysicalModels/radiation/lnInclude"
   else
     OPENFOAM_RADIATION_CPPFLAGS="-I${LIB_SRC}/thermophysicalModels/radiationModels/lnInclude"
   fi

   OPENFOAM_SPECIE_CPPFLAGS=""
   if test ${FOAM_VERSION} -ge 020000 ; then
     OPENFOAM_SPECIE_CPPFLAGS="-I${LIB_SRC}/thermophysicalModels/specie/lnInclude"   
   fi

   OPENFOAM_SOLID_CPPFLAGS=""
   if test ${FOAM_VERSION} -ge 020000 ; then
     OPENFOAM_SOLID_CPPFLAGS="-I${LIB_SRC}/thermophysicalModels/solid/lnInclude"   
   fi

   OPENFOAM_FINITEVOLUME_CPPFLAGS="-I${LIB_SRC}/finiteVolume/lnInclude"

   OPENFOAM_SAMPLING_CPPFLAGS="-I${LIB_SRC}/sampling/lnInclude"

   OPENFOAM_DYNAMICMESH_CPPFLAGS="-I${LIB_SRC}/dynamicMesh/lnInclude"
   if test "x${FOAM_BRANCH}" == "xdev" -a ${FOAM_VERSION} -ge 010600 ; then
      OPENFOAM_DYNAMICMESH_CPPFLAGS="${OPENFOAM_DYNAMICMESH_CPPFLAGS} -I${LIB_SRC}/dynamicMesh/dynamicMesh/lnInclude"
   fi

   OPENFOAM_DYNAMICFVMESH_CPPFLAGS="-I${LIB_SRC}/dynamicFvMesh/lnInclude"
   if test "x${FOAM_BRANCH}" == "xdev" -a ${FOAM_VERSION} -ge 010600 ; then
      OPENFOAM_DYNAMICFVMESH_CPPFLAGS="${OPENFOAM_DYNAMICFVMESH_CPPFLAGS} -I${LIB_SRC}/dynamicMesh/dynamicFvMesh/lnInclude"
   fi

   OPENFOAM_RANDOMPROCESS_CPPFLAGS="-I${LIB_SRC}/randomProcesses/lnInclude"

   OPENFOAM_TRANSPORTMODELS_CPPFLAGS="-I${LIB_SRC}/transportModels"

   OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_CPPFLAGS="-I${LIB_SRC}/transportModels/incompressible/lnInclude"

   OPENFOAM_TURBULENCEMODELS_CPPFLAGS="-I${LIB_SRC}/turbulenceModels"

   OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS=""
   if test ${FOAM_VERSION} -eq 010500 ; then
      OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS="${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS} -I${LIB_SRC}/turbulenceModels/LES/LESdeltas/lnInclude"
   elif test ${FOAM_VERSION} -ge 010600 ; then
      OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS="${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS} -I${LIB_SRC}/turbulenceModels/LES/LESdeltas/lnInclude"
   fi

   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS=""
   if test ${FOAM_VERSION} -ge 010700 ; then
      OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS} -I${LIB_SRC}/turbulenceModels/compressible/RAS/lnInclude"
   fi

   if test ${FOAM_VERSION} -ge 020000 ; then
      OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS} -I${LIB_SRC}/turbulenceModels/compressible/turbulenceModel/lnInclude"
   fi
   
   OPENFOAM_INTERFACEPROPERTIES_CPPFLAGS="-I${LIB_SRC}/transportModels/interfaceProperties/lnInclude"

   rm -fr conf.include.makefile
;;
esac


dnl --------------------------------------------------------------------------------
DEFINE_FOAM_VERSION="-D__FOAM_VERSION__=${FOAM_VERSION}"
OPENFOAM_CPPFLAGS="${OPENFOAM_CPPFLAGS} ${DEFINE_FOAM_VERSION}"


dnl --------------------------------------------------------------------------------
IFS_STORE=${IFS}
IFS=''
SWIG_DEFINE_BRANCHES=$(cat <<'EOTEXT'
%define __OPENFOAM_EXT__ 1 %enddef
%define __FREEFOAM__ 2 %enddef
EOTEXT
)

AC_SUBST(SWIG_DEFINE_BRANCHES)

CXX_DEFINE_BRANCHES=$(cat <<'EOTEXT'
#define __OPENFOAM_EXT__ 1
#define __FREEFOAM__ 2
EOTEXT
)
IFS=${IFS_STORE}

AC_SUBST(CXX_DEFINE_BRANCHES)


dnl --------------------------------------------------------------------------------
case "x${FOAM_BRANCH}" in
"xfree")
   DEFINE_FOAM_BRANCH="-D__FOAM_BRANCH__=__FREEFOAM__"
;;
"xdev")
   DEFINE_FOAM_BRANCH="-D__FOAM_BRANCH__=__OPENFOAM_EXT__"
;;
esac

OPENFOAM_CPPFLAGS="${OPENFOAM_CPPFLAGS} ${DEFINE_FOAM_BRANCH}"


dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_CC@ == "${OPENFOAM_CC}" )
AC_SUBST(OPENFOAM_CC)

AC_MSG_NOTICE( @OPENFOAM_GFLAGS@ == "${OPENFOAM_GFLAGS}" )
AC_SUBST(OPENFOAM_GFLAGS)

AC_MSG_NOTICE( @OPENFOAM_CPPFLAGS@ == "${OPENFOAM_CPPFLAGS}" )
AC_SUBST(OPENFOAM_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_CXXFLAGS@ == "${OPENFOAM_CXXFLAGS}" )
AC_SUBST(OPENFOAM_CXXFLAGS)

AC_MSG_NOTICE( @OPENFOAM_LINKLIBSO@ == "${OPENFOAM_LINKLIBSO}" )
AC_SUBST(OPENFOAM_LINKLIBSO)

AC_MSG_NOTICE( @OPENFOAM_LINKEXE@ == "${OPENFOAM_LINKEXE}" )
AC_SUBST(OPENFOAM_LINKEXE)

AC_MSG_NOTICE( @OPENFOAM_LINKLIBSO_LIBS@ == "${OPENFOAM_LINKLIBSO_LIBS}" )
AC_SUBST(OPENFOAM_LINKLIBSO_LIBS)

AC_MSG_NOTICE( @OPENFOAM_LINKEXE_LIBS@ == "${OPENFOAM_LINKEXE_LIBS}" )
AC_SUBST(OPENFOAM_LINKEXE_LIBS)

AC_MSG_NOTICE( @OPENFOAM_LDFLAGS@ == "${OPENFOAM_LDFLAGS}" )
AC_SUBST(OPENFOAM_LDFLAGS)

AC_MSG_NOTICE( @OPENFOAM_LIBS@ == "${OPENFOAM_LIBS}" )
AC_SUBST(OPENFOAM_LIBS)


dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_MESHTOOLS_CPPFLAGS@ == "${OPENFOAM_MESHTOOLS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_MESHTOOLS_CPPFLAGS)

OPENFOAM_MESHTOOLS_LIBS="${FOAM_LIBS_PREFIX}meshTools${FOAM_LIBS_SUFFIX}"
AC_MSG_NOTICE( @OPENFOAM_MESHTOOLS_LIBS@ == "${OPENFOAM_MESHTOOLS_LIBS}" )
AC_SUBST(OPENFOAM_MESHTOOLS_LIBS)

dnl --------------------------------------------------------------------------------
OPENFOAM_BASICTHERMOPHYSICALMODELS_LIBS="${FOAM_LIBS_PREFIX}basicThermophysicalModels${FOAM_LIBS_SUFFIX}"

if test ${FOAM_VERSION} -ge 020000 ; then
   OPENFOAM_BASICSOLIDTHERMO_LIBS="${FOAM_LIBS_PREFIX}basicSolidThermo${FOAM_LIBS_SUFFIX}"   
fi
   
if test ${FOAM_VERSION} -ge 020000 ; then
   OPENFOAM_THERMALPOROUSZONE_LIBS="${FOAM_LIBS_PREFIX}thermalPorousZone${FOAM_LIBS_SUFFIX}"   
fi

AC_MSG_NOTICE( @OPENFOAM_BASICTHERMOPHYSICALMODELS_CPPFLAGS@ == "${OPENFOAM_BASICTHERMOPHYSICALMODELS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_BASICTHERMOPHYSICALMODELS_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_BASICSOLIDTHERMO_CPPFLAGS@ == "${OPENFOAM_BASICSOLIDTHERMO_CPPFLAGS}" )
AC_SUBST(OPENFOAM_BASICSOLIDTHERMO_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_BASICTHERMOPHYSICALMODELS_LIBS@ == "${OPENFOAM_BASICTHERMOPHYSICALMODELS_LIBS}" )
AC_SUBST(OPENFOAM_BASICTHERMOPHYSICALMODELS_LIBS)

AC_MSG_NOTICE( @OPENFOAM_BASICSOLIDTHERMO_LIBS@ == "${OPENFOAM_BASICSOLIDTHERMO_LIBS}" )
AC_SUBST(OPENFOAM_BASICSOLIDTHERMO_LIBS)

AC_MSG_NOTICE( @OPENFOAM_THERMALPOROUSZONE_CPPFLAGS@ == "${OPENFOAM_THERMALPOROUSZONE_CPPFLAGS}" )
AC_SUBST(OPENFOAM_THERMALPOROUSZONE_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_THERMALPOROUSZONE_LIBS@ == "${OPENFOAM_THERMALPOROUSZONE_LIBS}" )
AC_SUBST(OPENFOAM_THERMALPOROUSZONE_LIBS)


dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_RADIATION_CPPFLAGS@ == "${OPENFOAM_RADIATION_CPPFLAGS}" )
AC_SUBST(OPENFOAM_RADIATION_CPPFLAGS)

OPENFOAM_RADIATION_LIBS=""
if test ${FOAM_VERSION} -ge 010500 -a ${FOAM_VERSION} -lt 020000 ; then
     OPENFOAM_RADIATION_LIBS="${OPENFOAM_RADIATION_LIBS} ${FOAM_LIBS_PREFIX}radiation${FOAM_LIBS_SUFFIX}"
elif test ${FOAM_VERSION} -ge 020000; then
   OPENFOAM_RADIATION_LIBS="${OPENFOAM_RADIATION_LIBS} ${FOAM_LIBS_PREFIX}radiationModels${FOAM_LIBS_SUFFIX}"
fi
AC_MSG_NOTICE( @OPENFOAM_RADIATION_LIBS@ == "${OPENFOAM_RADIATION_LIBS}" )
AC_SUBST(OPENFOAM_RADIATION_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_SPECIE_CPPFLAGS@ == "${OPENFOAM_SPECIE_CPPFLAGS}" )
AC_SUBST(OPENFOAM_SPECIE_CPPFLAGS)

AC_MSG_NOTICE( @OPENFOAM_SOLID_CPPFLAGS@ == "${OPENFOAM_SOLID_CPPFLAGS}" )
AC_SUBST(OPENFOAM_SOLID_CPPFLAGS)

OPENFOAM_SPECIE_LIBS="${FOAM_LIBS_PREFIX}specie${FOAM_LIBS_SUFFIX}"
AC_MSG_NOTICE( @OPENFOAM_SPECIE_LIBS@ == "${OPENFOAM_SPECIE_LIBS}" )
AC_SUBST(OPENFOAM_SPECIE_LIBS)


OPENFOAM_SOLID_LIBS=""
if test ${FOAM_VERSION} -ge 020000 ; then
   OPENFOAM_SOLID_LIBS="${FOAM_LIBS_PREFIX}solid${FOAM_LIBS_SUFFIX}"   
fi
AC_MSG_NOTICE( @OPENFOAM_SOLID_LIBS@ == "${OPENFOAM_SOLID_LIBS}" )
AC_SUBST(OPENFOAM_SOLID_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_FINITEVOLUME_CPPFLAGS@ == "${OPENFOAM_FINITEVOLUME_CPPFLAGS}" )
AC_SUBST(OPENFOAM_FINITEVOLUME_CPPFLAGS)

OPENFOAM_FINITEVOLUME_LIBS="${FOAM_LIBS_PREFIX}finiteVolume${FOAM_LIBS_SUFFIX}"
AC_MSG_NOTICE( @OPENFOAM_FINITEVOLUME_LIBS@ == "${OPENFOAM_FINITEVOLUME_LIBS}" )
AC_SUBST(OPENFOAM_FINITEVOLUME_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_SAMPLING_CPPFLAGS@ == "${OPENFOAM_SAMPLING_CPPFLAGS}" )
AC_SUBST(OPENFOAM_SAMPLING_CPPFLAGS)

OPENFOAM_SAMPLING_LIBS="${FOAM_LIBS_PREFIX}sampling${FOAM_LIBS_SUFFIX}"
AC_MSG_NOTICE( @OPENFOAM_SAMPLING_LIBS@ == "${OPENFOAM_SAMPLING_LIBS}" )
AC_SUBST(OPENFOAM_SAMPLING_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_DYNAMICMESH_CPPFLAGS@ == "${OPENFOAM_DYNAMICMESH_CPPFLAGS}" )
AC_SUBST(OPENFOAM_DYNAMICMESH_CPPFLAGS)

OPENFOAM_DYNAMICMESH_LIBS="${FOAM_LIBS_PREFIX}dynamicMesh${FOAM_LIBS_SUFFIX}"
AC_MSG_NOTICE( @OPENFOAM_DYNAMICMESH_LIBS@ == "${OPENFOAM_DYNAMICMESH_LIBS}" )
AC_SUBST(OPENFOAM_DYNAMICMESH_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_DYNAMICFVMESH_CPPFLAGS@ == "${OPENFOAM_DYNAMICFVMESH_CPPFLAGS}" )
AC_SUBST(OPENFOAM_DYNAMICFVMESH_CPPFLAGS)

OPENFOAM_DYNAMICFVMESH_LIBS="${FOAM_LIBS_PREFIX}dynamicFvMesh${FOAM_LIBS_SUFFIX}"
AC_MSG_NOTICE( @OPENFOAM_DYNAMICFVMESH_LIBS@ == "${OPENFOAM_DYNAMICFVMESH_LIBS}" )
AC_SUBST(OPENFOAM_DYNAMICFVMESH_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_RANDOMPROCESS_CPPFLAGS@ == "${OPENFOAM_RANDOMPROCESS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_RANDOMPROCESS_CPPFLAGS)

OPENFOAM_RANDOMPROCESS_LIBS="${FOAM_LIBS_PREFIX}randomProcesses${FOAM_LIBS_SUFFIX}"
AC_MSG_NOTICE( @OPENFOAM_RANDOMPROCESS_LIBS@ == "${OPENFOAM_RANDOMPROCESS_LIBS}" )
AC_SUBST(OPENFOAM_RANDOMPROCESS_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_TRANSPORTMODELS_CPPFLAGS@ == "${OPENFOAM_TRANSPORTMODELS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_TRANSPORTMODELS_CPPFLAGS)

OPENFOAM_TRANSPORTMODELS_LIBS=""
AC_MSG_NOTICE( @OPENFOAM_TRANSPORTMODELS_LIBS@ == "${OPENFOAM_TRANSPORTMODELS_LIBS}" )
AC_SUBST(OPENFOAM_TRANSPORTMODELS_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_CPPFLAGS@ == "${OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_CPPFLAGS)

OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_LIBS="${FOAM_LIBS_PREFIX}incompressibleTransportModels${FOAM_LIBS_SUFFIX}"
AC_MSG_NOTICE( @OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_LIBS@ == "${OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_LIBS}" )
AC_SUBST(OPENFOAM_INCOMPRESSIBLETRANSPORTMODELS_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_TURBULENCEMODELS_CPPFLAGS@ == "${OPENFOAM_TURBULENCEMODELS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_TURBULENCEMODELS_CPPFLAGS)

OPENFOAM_TURBULENCEMODELS_LIBS=""
AC_MSG_NOTICE( @OPENFOAM_TURBULENCEMODELS_LIBS@ == "${OPENFOAM_TURBULENCEMODELS_LIBS}" )
AC_SUBST(OPENFOAM_TURBULENCEMODELS_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS@ == "${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_CPPFLAGS)

OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS=""
if test ${FOAM_VERSION} -le 010401 ; then
   OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}incompressibleTurbulenceModels${FOAM_LIBS_SUFFIX}"
elif test ${FOAM_VERSION} -eq 010500 ; then
   OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}incompressibleLESModels${FOAM_LIBS_SUFFIX}"
   OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}incompressibleRASModels${FOAM_LIBS_SUFFIX}"
elif test ${FOAM_VERSION} -ge 010600 ; then
   OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}incompressibleLESModels${FOAM_LIBS_SUFFIX}"
   OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}incompressibleRASModels${FOAM_LIBS_SUFFIX}"
   OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}incompressibleTurbulenceModel${FOAM_LIBS_SUFFIX}"
fi
AC_MSG_NOTICE( @OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS@ == "${OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS}" )
AC_SUBST(OPENFOAM_INCOMPRESSIBLETURBULENCEMODELS_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS@ == "${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS}" )
AC_SUBST(OPENFOAM_COMPRESSIBLETURBULENCEMODELS_CPPFLAGS)

OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS=""
if test ${FOAM_VERSION} -le 010401 ; then
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}compressibleTurbulenceModels${FOAM_LIBS_SUFFIX}"
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS} ${OPENFOAM_SPECIE_LIBS}"
elif test ${FOAM_VERSION} -eq 010500 ; then
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}compressibleLESModels${FOAM_LIBS_SUFFIX}"
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}compressibleRASModels${FOAM_LIBS_SUFFIX}"
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS} ${OPENFOAM_SPECIE_LIBS}"
elif test ${FOAM_VERSION} -eq 010600 ; then
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}compressibleLESModels${FOAM_LIBS_SUFFIX}"
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}compressibleRASModels${FOAM_LIBS_SUFFIX}"
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}compressibleTurbulenceModel${FOAM_LIBS_SUFFIX}"
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS} ${OPENFOAM_SPECIE_LIBS}"
elif test ${FOAM_VERSION} -gt 010600 ; then
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}compressibleLESModels${FOAM_LIBS_SUFFIX}"
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}compressibleRASModels${FOAM_LIBS_SUFFIX}"
   OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS="${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS} ${FOAM_LIBS_PREFIX}compressibleTurbulenceModel${FOAM_LIBS_SUFFIX}"
fi

AC_MSG_NOTICE( @OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS@ == "${OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS}" )
AC_SUBST(OPENFOAM_COMPRESSIBLETURBULENCEMODELS_LIBS)

dnl --------------------------------------------------------------------------------
AC_MSG_NOTICE( @OPENFOAM_INTERFACEPROPERTIES_CPPFLAGS@ == "${OPENFOAM_INTERFACEPROPERTIES_CPPFLAGS}" )
AC_SUBST(OPENFOAM_INTERFACEPROPERTIES_CPPFLAGS)

OPENFOAM_INTERFACEPROPERTIES_LIBS="${FOAM_LIBS_PREFIX}interfaceProperties${FOAM_LIBS_SUFFIX}"
if test ${FOAM_VERSION} -ge 010701; then
   OPENFOAM_INTERFACEPROPERTIES_LIBS="${OPENFOAM_INTERFACEPROPERTIES_LIBS} ${FOAM_LIBS_PREFIX}twoPhaseInterfaceProperties${FOAM_LIBS_SUFFIX}"
fi
AC_MSG_NOTICE( @OPENFOAM_INTERFACEPROPERTIES_LIBS@ == "${OPENFOAM_INTERFACEPROPERTIES_LIBS}" )
AC_SUBST(OPENFOAM_INTERFACEPROPERTIES_LIBS)

foam_version=${FOAM_VERSION}
foam_branch=${FOAM_VERSION}


dnl --------------------------------------------------------------------------------
])


dnl --------------------------------------------------------------------------------

