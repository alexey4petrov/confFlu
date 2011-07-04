## pythonFlu - Python wrapping for OpenFOAM C++ API
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
DESTDIR=
confflu_path=$(DESTDIR)/usr/local/share/confFlu

BUILD_DIR=/usr/src/packages/BUILD
preparation_dir=$(BUILD_DIR)/confFlu

preparation:$(preparation_dir)/build_configure

$(preparation_dir)/build_configure:
	@ install -d $(preparation_dir)
	@ cp -rf admin build_configure env.sh Makefile $(preparation_dir)/
	@ mv $(preparation_dir)/env.sh $(preparation_dir)/bashrc

install: $(confflu_path)/build_configure

$(confflu_path)/build_configure: 
	@ install -d $(confflu_path)
	@ cp -rf $(preparation_dir)/* $(confflu_path)/



#--------------------------------------------------------------------------------------     	
