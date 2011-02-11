dnl VulaSHAKA (Simultaneous Neutronic, Fuel Performance, Heat And Kinetics Analysis)
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
dnl See https://vulashaka.svn.sourceforge.net/svnroot/vulashaka/conffoam
dnl
dnl Author : Alexey PETROV
dnl


dnl --------------------------------------------------------------------------------
AC_DEFUN([CONFFOAM_CHECK_PGP_KEY_ID],
[
  AC_MSG_NOTICE(define PGP key to sign deb package)
  
  AC_SUBST(PGP_KEY_ID)
  
  AC_ARG_WITH( [pgp_key_id],
             AC_HELP_STRING( [--with-pgp-key-id=<pgp key id>],
                             [use <pgp key id> to define PGP key to sign deb package ( "gpg --list-keys" to see keys)] ),
             [ with_pgp_key_id=$withval ],
             [ with_pgp_key_id="" ]  )


  PGP_KEY_ID=${with_pgp_key_id}
  
  AC_MSG_NOTICE( @PGP_KEY_ID@ == "${PGP_KEY_ID}" )
    
])


dnl --------------------------------------------------------------------------------

