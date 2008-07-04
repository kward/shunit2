#! /bin/sh
# $Id$
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
#
# Author: kate.ward@forestent.com (Kate Ward)
#
# shUnit2 unit test for assert functions

# load test helpers
. ./shunit2_test_helpers

#------------------------------------------------------------------------------
# suite tests
#

commonEqualsSame()
{
  fn=$1

  msg='same, with message'
  rslt=`${fn} "${MSG}" 'x' 'x' 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='same'
  rslt=`${fn} 'x' 'x' 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='not same'
  rslt=`${fn} 'x' 'y' 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}

  msg='null values'
  rslt=`${fn} '' '' 2>"${stderrF}"`
  rtrn=$?
  assertTrue "${msg}; failure" ${rtrn}
  [ ${rtrn} -ne ${SHUNIT_TRUE} ] && cat "${stderrF}"
  assertNull 'expected no output to STDOUT' "${rslt}"
  assertFalse 'expected no output to STDERR' "[ -s \"${stderrF}\" ]"

  # too few arguments
  ( ${fn} >"${stdoutF}" 2>"${stderrF}" )
  rtrn=$?
  assertFalse 'unexpected return value' ${rtrn}
  assertFalse 'expected no output to STDOUT' "[ -s '${stdoutF}' ]"
  assertTrue 'expected output to STDERR' "[ -s '${stderrF}' ]"

  # too many arguments
  ( ${fn} arg1 arg2 arg3 arg4 >"${stdoutF}" 2>"${stderrF}" )
  rtrn=$?
  assertFalse 'unexpected return value' ${rtrn}
  assertFalse 'expected no output to STDOUT' "[ -s '${stdoutF}' ]"
  assertTrue 'expected output to STDERR' "[ -s '${stderrF}' ]"
}

testAssertEquals()
{
  commonEqualsSame 'assertEquals'
}

testAssertSame()
{
  commonEqualsSame 'assertSame'
}

testAssertNotSame()
{
  msg='not same, with message'
  rslt=`assertNotSame "${MSG}" 'x' 'y' 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='not same'
  rslt=`assertNotSame 'x' 'y' 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='same'
  rslt=`assertNotSame 'x' 'x' 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}

  msg='null values'
  rslt=`assertNotSame '' '' 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}

  msg='too few arguments'
  rslt=`assertNotSame 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}
}

testAssertNull()
{
  msg='null, with message'
  rslt=`assertNull "${MSG}" '' 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='null'
  rslt=`assertNull '' 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='not null'
  rslt=`assertNull 'x' 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}

  # too few arguments
  ( assertNull >"${stdoutF}" 2>"${stderrF}" )
  rtrn=$?
  assertFalse 'unexpected return value' ${rtrn}
  assertFalse 'expected no output to STDOUT' "[ -s '${stdoutF}' ]"
  assertTrue 'expected output to STDERR' "[ -s '${stderrF}' ]"

  # too many arguments
  ( assertNull arg1 arg2 arg3 >"${stdoutF}" 2>"${stderrF}" )
  rtrn=$?
  assertFalse 'unexpected return value' ${rtrn}
  assertFalse 'expected no output to STDOUT' "[ -s '${stdoutF}' ]"
  assertTrue 'expected output to STDERR' "[ -s '${stderrF}' ]"
}

testAssertNotNull()
{
  msg='not null, with message'
  rslt=`assertNotNull "${MSG}" 'x' 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='not null'
  rslt=`assertNotNull 'x' 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='null'
  rslt=`assertNotNull '' 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}

  msg='too few arguments'
  rslt=`assertNotNull 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}
}

testAssertTrue()
{
  msg='true, with message'
  rslt=`assertTrue "${MSG}" 0 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='true'
  rslt=`assertTrue 0 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='true condition'
  rslt=`assertTrue "[ 0 -eq 0 ]" 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='false'
  rslt=`assertTrue 1 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}

  msg='false condition'
  rslt=`assertTrue "[ 0 -eq 1 ]" 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}

  msg='null value'
  rslt=`assertTrue '' 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}

  msg='too few arguments'
  rslt=`assertTrue 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}
}

testAssertFalse()
{
  msg='false, with message'
  rslt=`assertFalse "${MSG}" 1 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='false'
  rslt=`assertFalse 1 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='false condition'
  rslt=`assertFalse "[ 0 -eq 1 ]" 2>&1`
  rtrn=$?
  assertSame "${msg}" '' "${rslt}"
  assertTrue "${msg}; failure" ${rtrn}

  msg='true'
  rslt=`assertFalse 0 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}

  msg='true condition'
  rslt=`assertFalse "[ 0 -eq 0 ]" 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}

  msg='null value'
  rslt=`assertFalse '' 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}

  msg='too few arguments'
  rslt=`assertFalse 2>&1`
  rtrn=$?
  assertNotSame "${msg}" '' "${rslt}"
  assertFalse "${msg}; failure" ${rtrn}
}

#------------------------------------------------------------------------------
# suite functions
#

oneTimeSetUp()
{
  tmpDir="${__shunit_tmpDir}/output"
  mkdir "${tmpDir}"
  stdoutF="${tmpDir}/stdout"
  stderrF="${tmpDir}/stderr"

  MSG='This is a test message'
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${TH_SHUNIT}
