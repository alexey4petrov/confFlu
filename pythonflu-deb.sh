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
export DEBIAN_FRONTEND=noninteractive


#--------------------------------------------------------------------------------------
determine_packages()
{
  package_names=${1}
  install_packages=""
  for package_name in ${package_names}; do
      package_exist=`dpkg -s ${package_name} 2>/dev/null`
      if [ "x${package_exist}" == "x" ]; then
         install_packages=${install_packages}" ${package_name}"
      fi
  done
  if [ "x${install_packages}" != "x" ]; then
     sudo apt-get install -y --force-yes ${install_packages}
  fi
}

#--------------------------------------------------------------------------------------
check_openfoam()
{
  foam_exist=`dpkg -s ${__FOAM_PACKAGE_NAME__} 2>/dev/null`
  if [ "x${foam_exist}" != "x" ]; then
     export __FOAM_EXIST__=true
     export __FOAM_BASHRC_PATH__=`dpkg -L ${__FOAM_PACKAGE_NAME__} | grep etc/bashrc`
  fi
}


#--------------------------------------------------------------------------------------
install_foam()
{
   supported_codenames=$1
   foam_url=$2
   
   os_codename=`lsb_release -a 2>/dev/null | grep Codename | sed 's/Codename:\t//'`
   os_support=false
   for codename in ${supported_codenames}; do
       if [ "${codename}" == "${os_codename}" ]; then
          os_support=true
       fi
   done
   if [ ${os_support} == "false" ]; then
      echo "There is no OpenFOAM-${__FOAM_VERSION__} deb package for your OS( Codename: ${os_codename}"
      exit 1
   fi
  
   echo "-------------------------------------------------------------"
   echo "installing OpenFOAM-${__FOAM_VERSION__}....."
   echo "-------------------------------------------------------------"
   to_source_list="deb ${foam_url} ${os_codename} main"
   sudo bash -c "echo ${to_source_list} >> /etc/apt/sources.list"
   sudo apt-get update
   sudo apt-get install -y --force-yes ${__FOAM_PACKAGE_NAME__}
   echo "-------------------------------------------------------------"
}

#--------------------------------------------------------------------------------------
determine_openfoam()
{
  supported_codenames=$1
  foam_url=$2
  
  check_openfoam
  if [ "${__FOAM_EXIST__}" == "false" ]; then
     install_foam ${supported_codenames} ${foam_url}
  fi
}


#--------------------------------------------------------------------------------------
checkout_pythonflu()
{
  echo "-------------------------------------------------------------"
  echo " checkout pythonFlu....."
  echo "-------------------------------------------------------------"
  
  check_openfoam
  
  if [ "${__FOAM_EXIST__}" == "false" ]; then
     echo "$0: It is necessary to install OpenFOAM-${__FOAM_VERSION__}" >&2
     exit -1
  fi
  
  if [ -d ${__PYTHONFLU_FOLDER__} ]; then
     rm -rf ${__PYTHONFLU_FOLDER__}
  fi
  mkdir ${__PYTHONFLU_FOLDER__}
  
  svn co https://afgan.svn.sourceforge.net/svnroot/afgan/pyfoam/branches/r928_deb_packages/ ${__PYTHONFLU_FOLDER__}
  
  echo "source ${CONFFOAM_ROOT_DIR}/bashrc" > ${__PYTHONFLU_FOLDER__}/env_new.sh
  echo "source_openfoam ${__FOAM_BASHRC_PATH__}" >> ${__PYTHONFLU_FOLDER__}/env_new.sh
  
  mv ${__PYTHONFLU_FOLDER__}/env.sh ${__PYTHONFLU_FOLDER__}/env_old.sh
  mv ${__PYTHONFLU_FOLDER__}/env_new.sh ${__PYTHONFLU_FOLDER__}/env.sh
  echo "-------------------------------------------------------------"
}



#--------------------------------------------------------------------------------------
build_configure_pythonflu()
{
  bashrc_string=`cat ${__PYTHONFLU_FOLDER__}/env.sh | grep $CONFFOAM_ROOT_DIR`
  if  [ "x${bashrc_string}" = "x" ]; then
     echo "$0: There is no \"correct\" modified ${__PYTHONFLU_FOLDER__}/env.sh. It is necessary to checkout pythonFlu ( --step=checkout ) " >&2
     exit -1;
  fi
  source ${__PYTHONFLU_FOLDER__}/env.sh
  ( cd ${__PYTHONFLU_FOLDER__} && build_configure )
}


#--------------------------------------------------------------------------------------
configure_pythonflu()
{
  determine_packages "swig python-dev"
  
  if [ -f ${__PYTHONFLU_FOLDER__}/configure ]; then
       source ${__PYTHONFLU_FOLDER__}/env.sh
      ( cd ${__PYTHONFLU_FOLDER__} && ./configure --with-build-version=${__BUILD_VERSION__} --with-pgp-key-id=${__PGP_KEY_ID__} --disable-singlelib )
  else
     echo "$0: There is no \"configure\" file in \" ${__PYTHONFLU_FOLDER__}\". It is necessary to run build_configure pythonFlu ( --step=build_configure )" >&2
     exit -1
  fi
}


#--------------------------------------------------------------------------------------
make_pythonflu()
{
  if [ -f ${__PYTHONFLU_FOLDER__}/bashrc ]; then
     ( source ${__PYTHONFLU_FOLDER__}/env.sh && cd ${__PYTHONFLU_FOLDER__} && make )
  else
     echo "$0: There is no \"bashrc\" file in \" ${__PYTHONFLU_FOLDER__}\". It is necessary to run configure pythonFlu ( --step=configure )" >&2
     exit -1
  fi
  
}


#--------------------------------------------------------------------------------------
make_deb()
{
   determine_packages "expect dh-make dpkg-dev"
   source ${__PYTHONFLU_FOLDER__}/env.sh
   if [ "${__UPLOAD__}" = "true" ]; then
      ( cd ${__PYTHONFLU_FOLDER__} && make launchpad )
   else
      ( cd ${__PYTHONFLU_FOLDER__} && make deb )
   fi
}


#--------------------------------------------------------------------------------------
usage="\

Usage: $0 --foam-version=<foam version> --build-version=<build version> [--upload --pgp-key-id=<pgp key id>] [--step=<step name>]
Parameters:
       --foam_version=<foam version> - version of the OpenFOAM( 1.5-dev, 1.6-ext,1.7.0, 1.7.1 etc )
       --build-version=<build version> - our build number
       --upload  - create source package and upload it to the launchpad( or if It not exists create deb package )
       --pgp-key-id - pgp key id to sign package, to find it to run \"gpg --list-keys\"
       --step=<step name> - we begin with this <step name> ( checkout, build_configure, configure, make, deb )
Options:
       --help     display this help and exit.

"

#--------------------------------------------------------------------------------------
# Check is the first argument "--help" and then checking enviroment( variable CONFFOAM_ROOT_DIR exists )
if [ "x$1" = "x--help" ]; then
   echo "${usage}"
   exit 0
fi 
if [ "x${CONFFOAM_ROOT_DIR}" == "x" ]; then
   echo "$0: It is necessary to source CONFFOAM" >&2
   exit -1
fi


#--------------------------------------------------------------------------------------
# parsing the command line
foam_version_exist=false
build_version_exist=false
upload=false
step=all

for arg in $* ;  do
   correct_arg=false
   if [ `echo $arg | grep --regexp='--foam-version='` ]; then
      foam_version=`echo ${arg} | awk "-F=" '{print $2}'`
      foam_version_exist=true
      correct_arg=true
   fi  

   if [ "`echo $arg | grep --regexp='--build-version='`" ]; then
      build_version=`echo ${arg} | awk "-F=" '{print $2}'`
      build_version_exist=true
      correct_arg=true
   fi  

   if [ "`echo $arg | grep --regexp='--upload'`" ]; then
      upload=true
      correct_arg=true
   fi  
   
   if [ "`echo $arg | grep --regexp='--pgp-key-id='`" ]; then
      pgp_key_id=`echo ${arg} | awk "-F=" '{print $2}'`
      correct_arg=true
   fi  

   if [ "`echo $arg | grep --regexp='--step='`" ]; then
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

if [ "${upload}" = "true" ]; then
   if [ "x${pgp_key_id}" = "x" ]; then
      echo "$0: empty pgp key id. If you choice \"--upload\" option, it is necessary to define correct pgp key id. " >&2
      exit -1;
   fi
   
   count_pgp_key_id=0
   count_pgp_key_id=`gpg --list-keys | grep -c "${pgp_key_id}"`
   if [ ${count_pgp_key_id} -eq 0 ]; then
      echo "$0: There is no PGP key with id \"${pgp_key_id}\" in your system. If you choice \"--upload\" option, it is necessary to define correct pgp key id " >&2
      exit -1;
   fi
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

export __FOAM_VERSION__=${foam_version}
export __BUILD_VERSION__=${build_version}
export __PGP_KEY_ID__=${pgp_key_id}
export __PYTHONFLU_FOLDER__=`pwd`/pythonflu-deb-${__FOAM_VERSION__}-${__BUILD_VERSION__}
export __UPLOAD__=${upload}
export __FOAM_PACKAGE_NAME__=${foam_package_name}
export __FOAM_EXIST__=false #may be re-defined at "check_openfoam" function
export __FOAM_BASHRC_PATH__= #Will be assigned at "check_openfoam" function

case ${step} in
   all)
      determine_openfoam "${supported_codenames}" ${foam_url}
      checkout_pythonflu
      build_configure_pythonflu
      configure_pythonflu
      make_pythonflu
      make_deb
   ;;   
   checkout)
      checkout_pythonflu
      build_configure_pythonflu
      configure_pythonflu
      make_pythonflu
      make_deb
   ;;
   build_configure)
      build_configure_pythonflu
      configure_pythonflu 
      make_pythonflu
      make_deb
   ;;
   configure)
      configure_pythonflu 
      make_pythonflu
      make_deb
   ;;
   make)
      make_pythonflu
      make_deb
   ;;
   deb)
      make_deb
   ;;
   *)
      echo "$0: Unknown option step=${step}. The step option can take values \"checkout\", \"build_configure\", \"configure\",\"make\",\"deb\"." >&2
      exit -1
   ;;
esac


#--------------------------------------------------------------------------------------
