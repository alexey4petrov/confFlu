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
AC_DEFUN([CONFFOAM_CHECK_FOAM2VTK],dnl
[
AC_CHECKING(for foam2vtk package)

AC_REQUIRE([CONFFOAM_CHECK_OPENFOAM])

AC_REQUIRE([CONFFOAM_CHECK_VTK])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS

FOAM2VTK_CPPFLAGS=""
AC_SUBST(FOAM2VTK_CPPFLAGS)

FOAM2VTK_CXXFLAGS=""
AC_SUBST(FOAM2VTK_CXXFLAGS)

FOAM2VTK_LDFLAGS=""
AC_SUBST(FOAM2VTK_LDFLAGS)

FOAM2VTK_LIBS=""
AC_SUBST(FOAM2VTK_LIBS)

AC_SUBST(ENABLE_FOAM2VTK)

foam2vtk_ok=no

dnl --------------------------------------------------------------------------------
AC_ARG_WITH( [foam2vtk-includes],
             AC_HELP_STRING( [--with-foam2vtk-includes=<path>],
                             [use <path> to look for foam2vtk headers] ),
             [],
             [with_foam2vtk_includes=""])
   
foam2vtk_header_dir=${with_foam2vtk_includes}

if test "x${with_foam2vtk_includes}" = "x" ; then
   if test ! "x${FOAM2VTK_ROOT_DIR}" = "x" && test -d ${FOAM2VTK_ROOT_DIR} ; then
      foam2vtk_header_dir=${FOAM2VTK_ROOT_DIR}/lib
   fi
fi

AC_CHECK_FILE( [${foam2vtk_header_dir}/vtkFoamInterfaces.H], [ foam2vtk_includes=yes ], [ foam2vtk_includes=no ] )

if test "x${foam2vtk_includes}" = "xno" ; then
   foam2vtk_header_dir=/usr/local/include/foam2vtk
   AC_CHECK_FILE( [${foam2vtk_header_dir}/vtkFoamInterfaces.H], [ foam2vtk_includes=yes ], [ foam2vtk_includes=no ] )
fi

if test "x${foam2vtk_includes}" = "xyes" ; then
   FOAM2VTK_CPPFLAGS="-I${foam2vtk_header_dir}"
fi

if test "x${foam2vtk_includes}" = "xno" ; then
   AC_MSG_WARN( [use --with-foam2vtk-includes=<path> to define path to foam2vtk libraries] )
fi


dnl --------------------------------------------------------------------------------
AC_ARG_WITH( [foam2vtk-libraries],
             AC_HELP_STRING( [--with-foam2vtk-libraries=<path>],
                             [use <path> to look for foam2vtk libraries] ),
             [],
             [with_foam2vtk_libraries=""])

foam2vtk_libraries_dir=${with_foam2vtk_libraries}

if test "x${with_foam2vtk_libraries}" = "x" ; then
   if test ! "x${FOAM2VTK_ROOT_DIR}" = "x" && test -d ${FOAM2VTK_ROOT_DIR} ; then
      foam2vtk_libraries_dir="${FOAM2VTK_ROOT_DIR}/lib"
   fi
fi

AC_CHECK_FILE( [${foam2vtk_libraries_dir}/libfoam2vtk.so], [ foam2vtk_libraries=yes ], [ foam2vtk_libraries=no ] )

if test "x${foam2vtk_libraries}" = "xno" ; then
   foam2vtk_libraries_dir=/usr/local/lib
   AC_CHECK_FILE( [${foam2vtk_libraries_dir}/libfoam2vtk.so], [ foam2vtk_libraries=yes ], [ foam2vtk_libraries=no ] )
fi

if test "x${foam2vtk_libraries}" = "xyes" ; then
   FOAM2VTK_LDFLAGS="-L${foam2vtk_libraries_dir}"
   FOAM2VTK_LIBS="-lfoam2vtk"
dnl   AC_MSG_CHECKING( for linking to foam2vtk library )
dnl   AC_LINK_IFELSE( [ AC_LANG_PROGRAM( [ #include <vtkFoamInterfaces.H> ], [ new Foam::vtkFoamInterface< Foam::scalar >() ] ) ],
dnl                    [ foam2vtk_ok=yes ],
dnl                    [ foam2vtk_ok=no ] )
dnl   AC_MSG_RESULT( ${foam2vtk_ok} )
fi

if test "x${foam2vtk_libraries}" = "xno" ; then
   AC_MSG_WARN( [use --with-foam2vtk-libraries=<path> to define path to foam2vtk libraries] )
fi


dnl --------------------------------------------------------------------------------
AC_CHECK_PROG( [foam2vtk_exe], [foam2vtk], [yes], [no] )


dnl --------------------------------------------------------------------------------
foam2vtk_wrapper=no
foam2vtk_wrapper=[`python -c "import foam2vtk; print \"yes\"" 2>/dev/null`]


dnl --------------------------------------------------------------------------------
if test "${foam2vtk_libraries}" = "yes" && test "${foam2vtk_includes}" = "yes" && test "${foam2vtk_wrapper}" = "yes" && test "${foam2vtk_exe}" = "yes"; then 
   foam2vtk_ok=yes
fi

if test "x${foam2vtk_ok}" = "xno" ; then
   AC_MSG_WARN([use either \${FOAM2VTK_ROOT_DIR} or --with-foam2vtk=<path>])
fi

dnl --------------------------------------------------------------------------------
ENABLE_FOAM2VTK=${foam2vtk_ok}
])


dnl --------------------------------------------------------------------------------
