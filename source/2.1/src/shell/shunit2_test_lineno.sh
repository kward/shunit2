#! /bin/sh
# $Id: shunit2_test_asserts.sh 177 2008-07-07 17:16:36Z kate.ward@forestent.com $
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

testLineNo()
{
  # start skipping if LINENO not available
  [ -z "${LINENO:-}" ] && startSkipping

  ( ${_ASSERT_EQUALS_} 'x' 'y' >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] ' "${stderrF}" >/dev/null
  assertTrue $?

  ( ${_ASSERT_NULL_} 'x' >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] ' "${stderrF}" >/dev/null
  assertTrue $?

  ( ${_ASSERT_TRUE_} 0 >"${stdoutF}" 2>"${stderrF}" )
  grep '^ASSERT:\[[0-9]*\] ' "${stderrF}" >/dev/null
  assertTrue $?
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
