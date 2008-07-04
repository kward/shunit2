#! /bin/sh
# $Id$
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
#
# Author: kate.ward@forestent.com (Kate Ward)
#
# shUnit2 unit test for failure functions

# load common unit-test functions
. ./shunit2_test_helpers

#-----------------------------------------------------------------------------
# suite tests
#

commonNotEqualsSame()
{
  fn=$1

  msg='same, with message'
  rslt=`${fn} "${MSG}" 'x' 'x' 2>&1`
  assertNotSame "${msg}" '' "${rslt}"

  msg='same'
  rslt=`${fn} 'x' 'x' 2>&1`
  assertNotSame "${msg}" '' "${rslt}"

  msg='not same'
  rslt=`${fn} 'x' 'y' 2>&1`
  assertNotSame "${msg}" '' "${rslt}"

  msg='null values'
  rslt=`${fn} '' '' 2>&1`
  assertNotSame "${msg}" '' "${rslt}"

  msg='too few arguments'
  rslt=`${fn} 2>&1`
  assertNotSame "${msg}" '' "${rslt}"
}

testFail()
{
  msg='with message'
  rslt=`fail "${MSG}" 2>&1`
  assertNotSame "${msg}" '' "${rslt}"

  msg='without message'
  rslt=`fail 2>&1`
  assertNotSame "${msg}" '' "${rslt}"
}

testFailNotEquals()
{
  commonNotEqualsSame 'failNotEquals'
}

testFailSame()
{
  msg='same, with message'
  rslt=`failSame "${MSG}" 'x' 'x' 2>&1`
  assertNotSame "${msg}" '' "${rslt}"

  msg='same'
  rslt=`failSame 'x' 'x' 2>&1`
  assertNotSame "${msg}" '' "${rslt}"

  msg='not same'
  rslt=`failSame 'x' 'y' 2>&1`
  assertNotSame "${msg}" '' "${rslt}"

  msg='null values'
  rslt=`failSame '' '' 2>&1`
  assertNotSame "${msg}" '' "${rslt}"

  msg='too few arguments'
  rslt=`failSame 2>&1`
  assertNotSame "${msg}" '' "${rslt}"
}

testFailNotSame()
{
  commonNotEqualsSame 'failNotSame'
}

#-----------------------------------------------------------------------------
# suite functions
#

oneTimeSetUp()
{
  MSG='This is a test message'
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${TH_SHUNIT}
