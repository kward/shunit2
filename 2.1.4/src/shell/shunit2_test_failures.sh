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

testFail()
{
  ( fail >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'fail' $? "${stdoutF}" "${stderrF}"

  ( fail "${MSG}" >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'fail with msg' $? "${stdoutF}" "${stderrF}"

  ( fail arg1 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too many arguments' $? "${stdoutF}" "${stderrF}"
}

testFailNotEquals()
{
  ( failNotEquals 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'same' $? "${stdoutF}" "${stderrF}"

  ( failNotEquals "${MSG}" 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'same with msg' $? "${stdoutF}" "${stderrF}"

  ( failNotEquals 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'not same' $? "${stdoutF}" "${stderrF}"

  ( failNotEquals '' '' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'null values' $? "${stdoutF}" "${stderrF}"

  ( failNotEquals >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too few arguments' $? "${stdoutF}" "${stderrF}"

  ( failNotEquals arg1 arg2 arg3 arg4 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too many arguments' $? "${stdoutF}" "${stderrF}"
}

testFailSame()
{
  ( failSame 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'same' $? "${stdoutF}" "${stderrF}"

  ( failSame "${MSG}" 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'same with msg' $? "${stdoutF}" "${stderrF}"

  ( failSame 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'not same' $? "${stdoutF}" "${stderrF}"

  ( failSame '' '' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'null values' $? "${stdoutF}" "${stderrF}"

  ( failSame >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too few arguments' $? "${stdoutF}" "${stderrF}"

  ( failSame arg1 arg2 arg3 arg4 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too many arguments' $? "${stdoutF}" "${stderrF}"
}

#-----------------------------------------------------------------------------
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
