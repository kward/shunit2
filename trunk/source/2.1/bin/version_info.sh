#! /bin/sh
# $Id$
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright (c) 2008 Forest Enterprises
# All Rights Reserved
#
# Author: Kate Ward (kate.ward@forestent.com)
#
# Released under the LGPL (GNU Lesser General Public License)

# treat unset variables as an error
set -u

#-----------------------------------------------------------------------------
# functions
#

shellBash()
{
  _shell=$1

  ${_shell} --version 2>&1 \
  |grep 'GNU bash' \
  |sed 's/.*version \([^ ]*\).*/\1/'
}

shellDash()
{
  dpkg -l |grep ' dash ' |awk '{print $3}'
}

shellKsh()
{
  _shell=$1

  _version=`strings ${_shell} 2>&1 \
      |grep Version \
      |sed 's/^.*Version \(.*\)$/\1/;s/ s+ \$$//;s/ /-/g'`
  [ -z "${_version}" ] && _version=`shellPdksh ${_shell}`
  echo ${_version}
}

shellPdksh()
{
  _shell=$1

  strings ${_shell} 2>&1 \
  |grep 'PD KSH' \
  |sed -e 's/.*PD KSH \(.*\)/\1/;s/ /-/g'
}

shellZsh()
{
  _shell=$1

  echo 'echo ${ZSH_VERSION}' |${_shell}
}

reportVersion()
{
  _shell=$1
  _version=$2

  echo "shell:${_shell} version:${_version}"
}

#-----------------------------------------------------------------------------
# main
#

version=''

os_system=`uname -s`
os_release=`uname -r`
case ${os_system} in
  Cygwin)
    version='unknown'
    ;;
  Darwin)
    majorRelease='10'
    subRelease=`echo ${os_release} |sed 's/^[0-9]*\.\([0-9]*\)\.[0-9]*$/\1/'`
    case ${os_release} in
      8.*) minorRelease='4' ;;
      9.*) minorRelease='5' ;;
      *) minorRelease='X'; subRelease='X' ;;
    esac
    os='Mac OS X'
    version="${majorRelease}.${minorRelease}.${subRelease}"
    ;;
  Linux)
    os='Linux'
    if [ -r '/etc/lsb-release' ]; then
      . /etc/lsb-release
      version="${DISTRIB_ID}-${DISTRIB_RELEASE}"
    fi
    ;;
  SunOS)
    os='Solaris'
    version=`echo ${os_release} |sed 's/[0-9]*\.\([0-9]*\)/\1/'`
    ;;
  *)
    os='unknown'
    version='unknown'
    ;;
esac
echo "os:${os} version:${version}"

# note: /bin/sh not included as it is nearly always a sym-link, and if it isn't
# it is too much trouble to figure out what it is.
SHELLS='/bin/bash /bin/dash /bin/ksh /bin/pdksh /bin/zsh'
for shell in ${SHELLS}; do
  version=''

  if [ ! -x "${shell}" ]; then
    reportVersion ${shell} 'not_installed'
    continue
  fi

  case ${shell} in
    */sh)
      # this could be one of any number of shells. try until one fits.

      version=`shellBash ${shell}`
      # dash cannot be self determined yet
      [ -z "${version}" ] && version=`shellKsh ${shell}`
      # pdksh is covered in shellKsh()
      [ -z "${version}" ] && version=`shellZsh ${shell}`
      ;;

    */bash) version=`shellBash ${shell}` ;;

    */dash)
      # simply assuming Ubuntu Linux until somebody comes up with a better
      # test. the following test will return an empty string if dash is not
      # installed.
      version=`shellDash`
      ;;

    */ksh) version=`shellKsh ${shell}` ;;
    */pdksh) version=`shellPdksh ${shell}` ;;
    */zsh) version=`shellZsh ${shell}` ;;
  esac

  [ -z "${version}" ] && version='unknown'
  reportVersion ${shell} "${version}"
done
