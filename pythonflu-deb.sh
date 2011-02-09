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
usage="\
Usage: $0 foam_version build_number [-upload]
     foam_version - version of the OpenFOAM( 1.5-dev, 1.6-ext,1.7.0, 1.7.1 etc )
     build-number - our build number

Options:
     --help     display this help and exit.
     -upload    create source package and upload it to the launchpad( or if It not exists create deb package )
"


#--------------------------------------------------------------------------------------
install_foam()
{
  foam_version=${1}
  foam_package_name=${2}
  supported_codenames=${3} 
  foam_url=${4}

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
if [ $# -lt 2 ] || [ $# -gt 3 ]; then 
   echo "${usage}"
   exit 1
fi

if [ ${1} == "--help" ]; then 
   echo "${usage}"
   exit 0
fi


#--------------------------------------------------------------------------------------
#pparsing the command line
foam_version=${1}
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
     echo "Not supported( unknown ) OpenFOAM version. The supported versions are \"dev-1.5\", \"1.6-ext\",\"1.7.0\", \"1.7.1\" "
     exit -1
   ;;
esac

package_build=$2

deb_package=true
case "x$3" in
  "x-upload")
     deb_package=false
  ;;
  "x")
  ;;
  *)
    echo "${0}: invalid option: ${3}" >&2; echo "${usage}"
    exit 1 
  ;;
esac


#------------------------------------------------------------------------------------------------
# check openfoam and install it, if not installed, then source it 
foam_exist=`dpkg -s ${foam_package_name} 2>/dev/null`

if [ "x${foam_exist}" == "x" ]; then
   install_foam ${foam_version} ${foam_package_name} "${supported_codenames}" ${foam_url} 
fi

path_to_foam_bashrc=`dpkg -L ${foam_package_name} | grep etc/bashrc`

source ${path_to_foam_bashrc}


#------------------------------------------------------------------------------------------------
#checkout and build pythonflu
work_folder=`pwd`/deb-$RANDOM
mkdir ${work_folder}

conffoam_folder=${work_folder}/conffoam
mkdir ${conffoam_folder}

pythonflu_folder=${work_folder}/pythonflu
mkdir ${pythonflu_folder}

#svn co  https://afgan.svn.sourceforge.net/svnroot/afgan/conffoam/trunk/ ${conffoam_folder}
#svn co https://afgan.svn.sourceforge.net/svnroot/afgan/pyfoam/trunk/ ${pythonflu_folder}

svn co https://afgan.svn.sourceforge.net/svnroot/afgan/conffoam/branches/r930_deb_package/ ${conffoam_folder}
svn co https://afgan.svn.sourceforge.net/svnroot/afgan/pyfoam/branches/r928_deb_packages/ ${pythonflu_folder}
(cd ${conffoam_folder} && ./build_configure && ./configure )
source ${conffoam_folder}/bashrc
(cd ${pythonflu_folder} && build_configure && ./configure )

