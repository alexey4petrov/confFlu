dnl Copyright (C) 2009 Pebble Bed Modular Reactor (Pty) Limited (PBMR)
dnl 
dnl This library is free software; you can redistribute it and/or 
dnl modify it under the terms of the GNU Lesser General Public 
dnl License as published by the Free Software Foundation; either 
dnl version 2.1 of the License. 
dnl 
dnl This library is distributed in the hope that it will be useful, 
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of 
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
dnl Lesser General Public License for more details. 
dnl 
dnl You should have received a copy of the GNU Lesser General Public 
dnl License along with this library; if not, write to the Free Software 
dnl Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA 
dnl 
dnl See http://sourceforge.net/projects/pyfoam
dnl
dnl Author : Alexey PETROV
dnl


dnl --------------------------------------------------------------------------------
AC_DEFUN([CONFFOAM_CHECK_BOOST_PROGRAM_OPTIONS],dnl
[
AC_CHECKING(for Boost "program options" sub library)

AC_REQUIRE([CONFFOAM_CHECK_BOOST])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS

BOOST_PROGRAM_OPTIONS_CPPFLAGS=""
AC_SUBST(BOOST_PROGRAM_OPTIONS_CPPFLAGS)

BOOST_PROGRAM_OPTIONS_CXXFLAGS=""
AC_SUBST(BOOST_PROGRAM_OPTIONS_CXXFLAGS)

BOOST_PROGRAM_OPTIONS_LDFLAGS=""
AC_SUBST(BOOST_PROGRAM_OPTIONS_LDFLAGS)

BOOST_PROGRAM_OPTIONS_LIBSUFFIX="-mt"
AC_SUBST(BOOST_PROGRAM_OPTIONS_LIBSUFFIX)

boost_program_options_ok=no

AC_ARG_WITH( [boost],
             AC_HELP_STRING([--with-boost=<path>],
		            [use <path> to look for Boost installation]),
             [],
	     [withval=yes])
   
if test ! "x${withval}" = "xno" ; then
   AC_MSG_CHECKING( ${withval} )
   if test "x${withval}" = "xyes" ; then
      if test ! "x${BOOSTDIR}" = "x" && test -d ${BOOSTDIR} ; then
      	 boost_dir=${BOOSTDIR}
      else
	 boost_dir="/usr"
      fi
   else
      boost_dir=${withval}
   fi

   AC_CHECK_FILE( [${boost_dir}], [ boost_ok=yes ], [ boost_ok=no ] )

   if test "x${boost_ok}" = "xyes" ; then
      AC_CHECK_FILE( [${boost_dir}/lib/libboost_thread${BOOST_LIBSUFFIX}.so],
                     [ boost_ok=yes ], 
		     [ boost_ok=no ])
      if test "x${boost_ok}" = "xno" ; then
      	 BOOST_LIBSUFFIX=""
         AC_CHECK_FILE( [${boost_dir}/lib/libboost_thread${BOOST_LIBSUFFIX}.so],
                        [ boost_ok=yes ], 
		        [ boost_ok=no ])
      fi
   fi

   if test "x${boost_ok}" = "xyes" ; then
      test ! "x${boost_dir}" = "x/usr" && BOOST_CPPFLAGS="-I${boost_dir}/include"
      CPPFLAGS="${BOOST_CPPFLAGS}"

      BOOST_CXXFLAGS="-ftemplate-depth-40"
      CXXFLAGS="${BOOST_CXXFLAGS}"

      test ! "x${boost_dir}" = "x/usr" && BOOST_LDFLAGS="-L${loki_root_dir}/lib"
      LDFLAGS="${BOOST_LDFLAGS}"

      AC_CHECK_HEADERS( [boost/shared_ptr.hpp], [ boost_ok=yes ], [ boost_ok=no ] )

      if test "x${boost_ok}" = "xyes" ; then
         AC_MSG_CHECKING( Boost shared_ptr functionality )
      	 AC_LINK_IFELSE( [ AC_LANG_PROGRAM( [ [ #include <boost/shared_ptr.hpp> ] ],
      			                    [ [ boost::shared_ptr< int >( new int ) ] ] ) ],
					    [ boost_ok=yes ],
					    [ boost_ok=no ] )
         AC_MSG_RESULT( ${boost_ok} )
      fi
   fi

   if test "x${boost_ok}" = "xyes" ; then
      AC_MSG_CHECKING( Boost threading functionality )

      LIBS="-lboost_thread${BOOST_LIBSUFFIX}"

      AC_LINK_IFELSE( [ AC_LANG_PROGRAM( [ [ #include <boost/thread/thread.hpp> ] ],
      		                         [ [ struct TBody{ void operator()(){} }; boost::thread( TBody() ) ] ] ) ],
					 [ boost_ok=yes ],
					 [ boost_ok=no ] )
      AC_MSG_RESULT( ${boost_ok} )
   fi
fi

if test "x${boost_ok}" = "xno" ; then
   AC_MSG_ERROR([use either BOOSTDIR environement varaible or --with-boost=<path>])
fi

AC_LANG_RESTORE

])
