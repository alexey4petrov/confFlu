#!/bin/bash

## VulaSHAKA (Simultaneous Neutronic, Fuel Performance, Heat And Kinetics Analysis)
## Copyright (C) 2009-2010 Pebble Bed Modular Reactor (Pty) Limited (PBMR)
## 
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.
## 
## See https://vulashaka.svn.sourceforge.net/svnroot/vulashaka
##
## Author : Alexey PETROV
##


#--------------------------------------------------------------------------------------
install_foam()
{
   foam_package_name=$1
   supported_codenames=$2
   foam_url=$3
   
   os_codename=`lsb_release -a 2>/dev/null | grep Codename | sed 's/Codename:\t//'`
   os_support=false
   for codename in ${supported_codenames}; do
       if [ "${codename}" == "${os_codename}" ]; then
          os_support=true
       fi
   done
   if [ ${os_support} == "false" ]; then
      echo "There is no OpenFOAM-${foam_version} deb package for your OS( Codename: ${os_codename}"
      exit 1
   fi
  
   echo "-------------------------------------------------------------"
   echo "installing OpenFOAM-${foam_version}....."
   echo "-------------------------------------------------------------"
   to_source_list="deb ${foam_url} ${os_codename} main"
   sudo bash -c "echo ${to_source_list} >> /etc/apt/sources.list"
   sudo apt-get update
   sudo apt-get install ${foam_package_name}
   echo "-------------------------------------------------------------"
}


#--------------------------------------------------------------------------------------
source_foam()
{
  foam_package_name=${1}
  supported_codenames=${2} 
  foam_url=${3}
  foam_exist=`dpkg -s ${foam_package_name} 2>/dev/null`

  if [ "x${foam_exist}" == "x" ]; then
     install_foam ${foam_package_name} "${supported_codenames}" ${foam_url} 
  fi

  path_to_foam_bashrc=`dpkg -L ${foam_package_name} | grep etc/bashrc`
  source ${path_to_foam_bashrc}
}


#--------------------------------------------------------------------------------------
check_openfoam()
{
  foam_version=$1
  if [ "x${WM_PROJECT_VERSION}" != "x${foam_version}" ]; then
     echo "$0: The current OpenFOAM version is \"${WM_PROJECT_VERSION}\" and not equal \"${foam_version}\". It is necessary to source OpenFOAM-${foam_version}\
          or define another OpenFAOM in command line with --foam-version=" >&2
     exit -1
  fi
  
  export PATH_TO_FOAM_BASHRC=${WM_PROJECT_DIR}/etc/bashrc
}


#--------------------------------------------------------------------------------------
checkout_pythonflu()
{
  echo "-------------------------------------------------------------"
  echo " checkout pythonFlu....."
  echo "-------------------------------------------------------------"
  
  check_openfoam ${foam_version}
  working_folder=`pwd`/pythonflu-deb-${foam_version}-${build_version}

  if [ -d ${working_folder} ]; then
     rm -rf ${working_folder}
  fi
  mkdir ${working_folder}
  
  pythonflu_folder=${working_folder}/pythonflu
  mkdir ${pythonflu_folder}
  
  svn co https://afgan.svn.sourceforge.net/svnroot/afgan/pyfoam/branches/r928_deb_packages/ ${pythonflu_folder}
  
  echo "source ${CONFFOAM_ROOT_DIR}/bashrc" > ${pythonflu_folder}/env_new.sh
  echo "source_openfoam ${PATH_TO_FOAM_BASHRC}" >> ${pythonflu_folder}/env_new.sh
  
  mv ${pythonflu_folder}/env.sh ${pythonflu_folder}/env_old.sh
  mv ${pythonflu_folder}/env_new.sh ${pythonflu_folder}/env.sh
  echo "-------------------------------------------------------------"
}



#--------------------------------------------------------------------------------------
build_configure_pythonflu()
{
  working_folder=`pwd`/pythonflu-deb-${foam_version}-${build_version}
  pythonflu_folder=${working_folder}/pythonflu
  
  bashrc_string=`cat ${pythonflu_folder}/env.sh | grep $CONFFOAM_ROOT_DIR`
  if  [ "x${bashrc_string}" = "x" ]; then
     echo "$0: There is no \"correct\" modified ${pythonflu_folder}/env.sh. It is necessary to checkout pythonFlu ( --step=checkout ) "
     exit -1;
  fi
  source ${pythonflu_folder}/env.sh
  ( cd ${pythonflu_folder} && build_configure )
}


#--------------------------------------------------------------------------------------
configure_pythonflu()
{
  working_folder=`pwd`/pythonflu-deb-${foam_version}-${build_version}
  pythonflu_folder=${working_folder}/pythonflu
  if [ -f ${pythonflu_folder}/configure ]; then
       source ${pythonflu_folder}/env.sh
      ( cd ${pythonflu_folder} && ./configure build_version=${build_version} --disable-singlelib )
  else
     echo "$0: There is no \"configure\" file in \" ${pythonflu_folder}\". It is necessary to run build_configure pythonFlu ( --step=build_configure )"
     exit -1
  fi
}

#--------------------------------------------------------------------------------------
make_pythonflu()
{
  working_folder=`pwd`/pythonflu-deb-${foam_version}-${build_version}
  pythonflu_folder=${working_folder}/pythonflu
  if [ -f ${pythonflu_folder}/bashrc ]; then
     source ${pythonflu_folder}/bashrc
     ( cd ${pythonflu_folder} && make )
  else
     echo "$0: There is no \"bashrc\" file in \" ${pythonflu_folder}\". It is necessary to run configure pythonFlu ( --step=configure )"
     exit -1
  fi
  
}

#--------------------------------------------------------------------------------------
usage="\

Usage: $0 --foam-version=<foam version> --build-version=<build version> [--upload] [--step=<step name>]
Parameters:
       --foam_version=<foam version> - version of the OpenFOAM( 1.5-dev, 1.6-ext,1.7.0, 1.7.1 etc )
       --build-version=<build version> - our build number
       --upload    create source package and upload it to the launchpad( or if It not exists create deb package )
       --step=<step name> - we begin with this <step name> ( checkout, build_configure, configure, make, deb )
Options:
       --help     display this help and exit.

"

#--------------------------------------------------------------------------------------
#Check is the first argument "--help" and then checking enviroment( variable CONFFOAM_ROOT_DIR exists )
if [ "x$1" = "x--help" ]; then
   echo "${usage}"
   exit 0
fi 
if [ "x${CONFFOAM_ROOT_DIR}" == "x" ]; then
   echo "$0: It is necessary to source CONFFOAM" >&2
   exit -1
fi


#--------------------------------------------------------------------------------------
#parsing the command line
foam_version_exist=false
build_version_exist=false
upload=false
step=all

for arg in $* ;  do
   correct_arg=false
   if [ `echo $arg | grep foam-version=` ]; then
      foam_version=`echo ${arg} | awk "-F=" '{print $2}'`
      foam_version_exist=true
      correct_arg=true
   fi  

   if [ "`echo $arg | grep build-version=`" ]; then
      build_version=`echo ${arg} | awk "-F=" '{print $2}'`
      build_version_exist=true
      correct_arg=true
   fi  

   if [ "`echo $arg | grep upload`" ]; then
      upload=true
      correct_arg=true
   fi  
   if [ "`echo $arg | grep step=`" ]; then
      step=`echo ${arg} | awk "-F=" '{print $2}'`
      correct_arg=true
   fi  

   if [ "${correct_arg}" == "false" ]; then
      echo "${0}: invalid option: ${arg}" >&2; echo "${usage}"
      exit -1;
   fi  
done 

if [ "${foam_version_exist}" == "false" ]; then
   echo; echo "${0}: missing mandatory parameter foam_version" >&2; echo
   echo "${usage}"; exit -1
fi

if [ "${build_version_exist}" == "false" ]; then
   echo; echo "${0}: missing mandatory parameter build_version"  >&2; echo
   echo "${usage}"; exit -1
fi


foam_package_name=""
supported_codenames=""
foam_url=""

case ${foam_version} in
   1.5-dev)
      foam_package_name="openfoam-dev-1.5"
      supported_codenames="lucid"
      foam_url="http://ppa.launchpad.net/cae-team/ppa/ubuntu"
   ;;
   1.6-ext)
      foam_package_name="openfoam-1.6-ext"
      supported_codenames="lucid"
      foam_url="http://ppa.launchpad.net/cae-team/ppa/ubuntu"
   ;;
   1.7.0)
      foam_package_name="openfoam170"
      supported_codenames="lucid"
      foam_url="http://www.openfoam.com/download/ubuntu"
   ;;
   1.7.1)
      foam_package_name="openfoam171"
      supported_codenames="lucid maverick"
      foam_url="http://www.openfoam.com/download/ubuntu"
   ;;
   *)
     echo "$0:Not supported( unknown ) OpenFOAM version. The supported versions are \"1.5-dev\", \"1.6-ext\",\"1.7.0\", \"1.7.1\" " >&2
     exit -1
   ;;
esac

export foam_version=${foam_version}
export build_version=${build_version}

case ${step} in
   all)
      source_foam ${foam_package_name} "${supported_codenames}" ${foam_url}
      checkout_pythonflu
      build_configure_pythonflu
      configure_pythonflu
      make_pythonflu 
   ;;   
   checkout)
      checkout_pythonflu
      build_configure_pythonflu
      configure_pythonflu
      make_pythonflu
   ;;
   build_configure)
      build_configure_pythonflu
      configure_pythonflu 
      make_pythonflu
   ;;
   configure)
      configure_pythonflu 
      make_pythonflu
   ;;
   make)
      make_pythonflu
   ;;
   deb)
      echo ${step}; 
   ;;
   *)
      echo "$0: Unknown option step=${step}. The step option can take values \"checkout\", \"build_configure\", \"configure\",\"make\",\"deb\"." >&2
      exit -1
   ;;
esac


