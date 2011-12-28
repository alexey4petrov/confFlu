## confFlu - pythonFlu configuration package
## Copyright (C) 2010- Alexey Petrov
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
## See http://sourceforge.net/projects/pythonflu
##
## Author : Alexey PETROV
##


#--------------------------------------------------------------------------------------
source_openfoam()
{
   if test "${WM_PROJECT_DIR}x" = "x" ; then
      # To prevent data to be overriden 
      tmp_PATH=${PATH}
      tmp_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
      
      source $*
      echo WM_PROJECT_DIR=\"${WM_PROJECT_DIR}\"

      export PATH=${PATH}:${tmp_PATH}
      export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${tmp_LD_LIBRARY_PATH}
   fi
}


#------------------------------------------------------------------------------
source_salome()
{
   if test "${KERNEL_ROOT_DIR}x" = "x" ; then
      source $*
      echo KERNEL_ROOT_DIR=\"${KERNEL_ROOT_DIR}\"
   fi
}


#--------------------------------------------------------------------------------------
