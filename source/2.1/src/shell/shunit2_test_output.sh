#! /bin/sh
# $Id: shunit2_test_asserts.sh 177 2008-07-07 17:16:36Z kate.ward@forestent.com $
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
#
# Author: kate.ward@forestent.com (Kate Ward)
#
# shUnit2 unit test for actual output
#
# Note: test scripts are prefixed with '#' chars so that shUnit2 does not
# incorrectly intrepret imbeded functions as real functions.

# load test helpers
. ./shunit2_test_helpers

#------------------------------------------------------------------------------
# suite tests
#

testUnboundVariable()
{
  sed 's/^#//' >"${testF}" <<EOF
#boom() { x=\$1; }
#test_boom()
#{
#   assertEquals 1 1
#   boom  # No parameter given
#   assertEquals 0 \$?
#}
#. ${TH_SHUNIT}
EOF
  ( exec sh "${testF}" >"${stdoutF}" 2>"${stderrF}" )
  rtrn=$?
  assertFalse 'expected a non-zero exit value' ${rtrn}
  grep '^# Test report' "${stdoutF}" >/dev/null
  assertTrue 'report was not generated' $?
  grep '^ASSERT:Unknown failure' "${stderrF}" >/dev/null
  assertTrue 'failure message was not generated' $?
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
  testF="${tmpDir}/unittest"
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${TH_SHUNIT}
