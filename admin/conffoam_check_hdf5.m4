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
AC_DEFUN([CONFFOAM_CHECK_HDF5],
[
AC_CHECKING(for HDF5 environemnt)

AC_LANG_SAVE
AC_LANG([C])

HDF5_CPPFLAGS=""
AC_SUBST(HDF5_CPPFLAGS)

HDF5_CFLAGS=""
AC_SUBST(HDF5_CFLAGS)

HDF5_LDFLAGS=""
AC_SUBST(HDF5_LDFLAGS)

hdf5_ok=yes

dnl --------------------------------------------------------------------------------
AC_CHECK_PROG( [hdf5_ok], [h5dump], [yes], [no] )

if test "x${hdf5_ok}" = "xno" ; then
   AC_MSG_WARN( [HDF5 need to be installed to continue] )
fi

hdf5_app=`which h5dump`
hdf5_app_dir=`dirname ${hdf5_app}`
hdf5_home=`(cd ${hdf5_app_dir}/..; pwd)`

dnl --------------------------------------------------------------------------------
hdf5_includes_ok=no
AC_ARG_WITH( [hdf5_includes],
             AC_HELP_STRING( [--with-hdf5-includes=<path>],
                             [use <path> to look for HDF5 includes] ),
             [],
             [ with_hdf5_includes=no ] )

if test "x${with_hdf5_includes}" = "xno" ; then
   with_hdf5_includes="${hdf5_home}/include"
   AC_CHECK_FILE( [${with_hdf5_includes}/hdf5.h], [ hdf5_includes_ok=yes ], [ hdf5_includes_ok=no ] )
fi

if test "x${hdf5_includes_ok}" = "xno" ; then
   with_hdf5_includes="/usr/include"
   AC_CHECK_FILE( [${with_hdf5_includes}/hdf5.h], [ hdf5_includes_ok=yes ], [ hdf5_includes_ok=no ] )
fi

if test "x${hdf5_includes_ok}" = "xyes" ; then
   test ! "x${with_hdf5_includes}" = "x/usr/include" && HDF5_CPPFLAGS="-I${with_hdf5_includes}"
   HDF5_CPPFLAGS="${HDF5_CPPFLAGS} -DH5_USE_16_API"
   CPPFLAGS="${HDF5_CPPFLAGS}"

   AC_CHECK_HEADERS( [hdf5.h], [ hdf5_includes_ok=yes ], [ hdf5_includes_ok=no ] )
fi

if test "x${hdf5_includes_ok}" = "xno" ; then
   AC_MSG_WARN( [use --with-hdf5-includes=<path> to define HDF5 header files location] )
fi

dnl --------------------------------------------------------------------------------
hdf5_libraries_ok=no
AC_ARG_WITH( [hdf5_libraries],
             AC_HELP_STRING( [--with-hdf5-libraries=<path>],
                             [use <path> to look for HDF5 libraries] ),
             [],
             [ with_hdf5_libraries=no ]  )
   
if test "x${with_hdf5_libraries}" = "xno" ; then
   with_hdf5_libraries=${hdf5_home}/lib
   AC_CHECK_FILE( [${with_hdf5_libraries}/libhdf5.so], [ hdf5_libraries_ok=yes ], [ hdf5_libraries_ok=no ] )
fi

if test "x${hdf5_libraries_ok}" = "xno" ; then
   with_hdf5_libraries=/usr/lib
   AC_CHECK_FILE( [${with_hdf5_libraries}/libhdf5.so], [ hdf5_libraries_ok=yes ], [ hdf5_libraries_ok=no ] )
fi


if test "x${hdf5_libraries_ok}" = "xyes" ; then
   HDF5_CFLAGS=""
   CFLAGS="${HDF5_CXXFLAGS}"

   HDF5_LDFLAGS="-lhdf5"
   test ! "x${with_hdf5_libraries}" = "x/usr/lib" && HDF5_LDFLAGS="-L${with_hdf5_libraries} ${HDF5_LDFLAGS}"
   LDFLAGS=${HDF5_LDFLAGS}

   AC_MSG_CHECKING( for linking to HDF5 libraries )
   AC_LINK_IFELSE( [ AC_LANG_PROGRAM( [ #include <hdf5.h> ], [ H5Tcopy( H5T_C_S1 ) ] ) ],
                   [ hdf5_libraries_ok=yes ],
                   [ hdf5_libraries_ok=no ] )
   AC_MSG_RESULT( ${hdf5_libraries_ok} )
fi

if test "x${hdf5_libraries_ok}" = "xno" ; then
   AC_MSG_WARN( [use --with-hdf5-libraries=<path> to define HDF5 libraries location] )
fi

dnl --------------------------------------------------------------------------------
if test "x${hdf5_includes_ok}" = "xyes" && test "x${hdf5_libraries_ok}" = "xyes" ; then
   hdf5_ok="yes"
fi

AC_LANG_RESTORE
])


dnl --------------------------------------------------------------------------------
