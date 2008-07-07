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

  ( ${fn} 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'equal' $? "${stdoutF}" "${stderrF}"

  ( ${fn} "${MSG}" 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'equal; with msg' $? "${stdoutF}" "${stderrF}"

  ( ${fn} 'abc def' 'abc def' >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'equal with spaces' $? "${stdoutF}" "${stderrF}"

  ( ${fn} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'not equal' $? "${stdoutF}" "${stderrF}"

  ( ${fn} '' '' >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'null values' $? "${stdoutF}" "${stderrF}"

  ( ${fn} arg1 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too few arguments' $? "${stdoutF}" "${stderrF}"

  ( ${fn} arg1 arg2 arg3 arg4 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too many arguments' $? "${stdoutF}" "${stderrF}"
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
  ( assertNotSame 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'not same' $? "${stdoutF}" "${stderrF}"

  ( assertNotSame "${MSG}" 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'not same, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertNotSame 'x' 'x' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'same' $? "${stdoutF}" "${stderrF}"

  ( assertNotSame '' '' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'null values' $? "${stdoutF}" "${stderrF}"

  ( assertNotSame arg1 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too few arguments' $? "${stdoutF}" "${stderrF}"

  ( assertNotSame arg1 arg2 arg3 arg4 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too many arguments' $? "${stdoutF}" "${stderrF}"
}

testAssertNull()
{
  ( assertNull '' >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'null' $? "${stdoutF}" "${stderrF}"

  ( assertNull "${MSG}" '' >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'null, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertNull 'x' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'not null' $? "${stdoutF}" "${stderrF}"

  ( assertNull >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too few arguments' $? "${stdoutF}" "${stderrF}"

  ( assertNull arg1 arg2 arg3 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too many arguments' $? "${stdoutF}" "${stderrF}"
}

testAssertNotNull()
{
  ( assertNotNull 'x' >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'not null' $? "${stdoutF}" "${stderrF}"

  ( assertNotNull "${MSG}" 'x' >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'not null, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertNotNull '' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'null' $? "${stdoutF}" "${stderrF}"

  ( assertNotNull >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too few arguments' $? "${stdoutF}" "${stderrF}"

  ( assertNotNull arg1 arg2 arg3 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too many arguments' $? "${stdoutF}" "${stderrF}"
}

testAssertTrue()
{
  ( assertTrue 0 >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'true' $? "${stdoutF}" "${stderrF}"

  ( assertTrue "${MSG}" 0 >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'true, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertTrue '[ 0 -eq 0 ]' >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'true condition' $? "${stdoutF}" "${stderrF}"

  ( assertTrue 1 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'false' $? "${stdoutF}" "${stderrF}"

  ( assertTrue '[ 0 -eq 1 ]' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'false condition' $? "${stdoutF}" "${stderrF}"

  ( assertTrue '' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'null' $? "${stdoutF}" "${stderrF}"

  ( assertTrue >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too few arguments' $? "${stdoutF}" "${stderrF}"

  ( assertTrue arg1 arg2 arg3 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too many arguments' $? "${stdoutF}" "${stderrF}"
}

testAssertFalse()
{
  ( assertFalse 1 >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'false' $? "${stdoutF}" "${stderrF}"

  ( assertFalse "${MSG}" 1 >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'false, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertFalse '[ 0 -eq 1 ]' >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'false condition' $? "${stdoutF}" "${stderrF}"

  ( assertFalse 0 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'true' $? "${stdoutF}" "${stderrF}"

  ( assertFalse '[ 0 -eq 0 ]' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'true condition' $? "${stdoutF}" "${stderrF}"

  ( assertFalse '' >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'true condition' $? "${stdoutF}" "${stderrF}"

  ( assertFalse >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too few arguments' $? "${stdoutF}" "${stderrF}"

  ( assertFalse arg1 arg2 arg3 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithSE 'too many arguments' $? "${stdoutF}" "${stderrF}"
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
