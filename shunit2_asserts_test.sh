#! /bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# shunit2 unit test for assert functions.
#
# Copyright 2008-2021 Kate Ward. All Rights Reserved.
# Released under the Apache 2.0 license.
# http://www.apache.org/licenses/LICENSE-2.0
#
# Author: kate.ward@forestent.com (Kate Ward)
# https://github.com/kward/shunit2
#
# In this file, all assert calls under test must be wrapped in () so they do not
# influence the metrics of the test itself.
#
# Disable source following.
#   shellcheck disable=SC1090,SC1091

# These variables will be overridden by the test helpers.
stdoutF="${TMPDIR:-/tmp}/STDOUT"
stderrF="${TMPDIR:-/tmp}/STDERR"

# Load test helpers.
. ./shunit2_test_helpers

commonEqualsSame() {
  fn=$1

  # These should succeed.

  desc='equal'
  if (${fn} 'x' 'x' >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi

  desc='equal_with_message'
  if (${fn} 'some message' 'x' 'x' >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi

  desc='equal_with_spaces'
  if (${fn} 'abc def' 'abc def' >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi

  desc='equal_null_values'
  if (${fn} '' '' >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi

  # These should fail.

  desc='not_equal'
  if (${fn} 'x' 'y' >"${stdoutF}" 2>"${stderrF}"); then
    fail "${desc}: expected a failure"
    _showTestOutput
  else
    th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  fi
}

commonNotEqualsSame() {
  fn=$1

  # These should succeed.

  desc='not_same'
  if (${fn} 'x' 'y' >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi

  desc='not_same_with_message'
  if (${fn} 'some message' 'x' 'y' >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi

  # These should fail.

  desc='same'
  if (${fn} 'x' 'x' >"${stdoutF}" 2>"${stderrF}"); then
    fail "${desc}: expected a failure"
    _showTestOutput
  else
    th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  fi

  desc='unequal_null_values'
  if (${fn} '' '' >"${stdoutF}" 2>"${stderrF}"); then
    fail "${desc}: expected a failure"
    _showTestOutput
  else
    th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  fi
}

testAssertEquals()    { commonEqualsSame 'assertEquals'; }
testAssertNotEquals() { commonNotEqualsSame 'assertNotEquals'; }
testAssertSame()      { commonEqualsSame 'assertSame'; }
testAssertNotSame()   { commonNotEqualsSame 'assertNotSame'; }

testAssertContains() {
  # Content is present.
  while read -r desc container content; do
    if (assertContains "${container}" "${content}" >"${stdoutF}" 2>"${stderrF}"); then
      th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
    else
      fail "${desc}: unexpected failure"
      _showTestOutput
    fi
  done <<EOF
abc_at_start  abcdef abc
bcd_in_middle abcdef bcd
def_at_end    abcdef def
EOF

  # Content missing.
  while read -r desc container content; do
    if (assertContains "${container}" "${content}" >"${stdoutF}" 2>"${stderrF}"); then
      fail "${desc}: unexpected failure"
      _showTestOutput
    else
      th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
    fi
  done <<EOF
xyz_not_present    abcdef xyz
zab_contains_start abcdef zab
efg_contains_end   abcdef efg
acf_has_parts      abcdef acf
EOF

  desc="content_starts_with_dash"
  if (assertContains 'abc -Xabc def' '-Xabc' >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi

  desc="contains_with_message"
  if (assertContains 'some message' 'abcdef' 'abc' >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi
}

testAssertNotContains() {
  # Content not present.
  while read -r desc container content; do
    if (assertNotContains "${container}" "${content}" >"${stdoutF}" 2>"${stderrF}"); then
      th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
    else
      fail "${desc}: unexpected failure"
      _showTestOutput
    fi
  done <<EOF
xyz_not_present    abcdef xyz
zab_contains_start abcdef zab
efg_contains_end   abcdef efg
acf_has_parts      abcdef acf
EOF

  # Content present.
  while read -r desc container content; do
    if (assertNotContains "${container}" "${content}" >"${stdoutF}" 2>"${stderrF}"); then
      fail "${desc}: expected a failure"
      _showTestOutput
    else
      th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
    fi
  done <<EOF
abc_is_present abcdef abc
EOF

  desc='not_contains_with_message'
  if (assertNotContains 'some message' 'abcdef' 'xyz' >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi
}

testAssertNull() {
  while read -r desc value; do
    if (assertNull "${value}" >"${stdoutF}" 2>"${stderrF}"); then
      fail "${desc}: unexpected failure"
      _showTestOutput
    else
      th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
    fi
  done <<'EOF'
x_alone          x
x_double_quote_a x"a
x_single_quote_a x'a
x_dollar_a       x$a
x_backtick_a     x`a
EOF

  desc='null_without_message'
  if (assertNull '' >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi

  desc='null_with_message'
  if (assertNull 'some message' '' >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi

  desc='x_is_not_null'
  if (assertNull 'x' >"${stdoutF}" 2>"${stderrF}"); then
    fail "${desc}: expected a failure"
    _showTestOutput
  else
    th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  fi
}

testAssertNotNull() {
  while read -r desc value; do
    if (assertNotNull "${value}" >"${stdoutF}" 2>"${stderrF}"); then
      th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
    else
      fail "${desc}: unexpected failure"
      _showTestOutput
    fi
  done <<'EOF'
x_alone          x
x_double_quote_b x"b
x_single_quote_b x'b
x_dollar_b       x$b
x_backtick_b     x`b
EOF

  desc='not_null_with_message'
  if (assertNotNull 'some message' 'x' >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi

  desc="double_ticks_are_null"
  if (assertNotNull '' >"${stdoutF}" 2>"${stderrF}"); then
    fail "${desc}: expected a failure"
    _showTestOutput
  else
    th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  fi
}

testAssertTrue() {
  # True values.
  while read -r desc value; do
    if (assertTrue "${value}" >"${stdoutF}" 2>"${stderrF}"); then
      th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
    else
      fail "${desc}: unexpected failure"
      _showTestOutput
    fi
  done <<'EOF'
zero         0
zero_eq_zero [ 0 -eq 0 ]
EOF

  # Not true values.
  while read -r desc value; do
    if (assertTrue "${value}" >"${stdoutF}" 2>"${stderrF}"); then
      fail "${desc}: expected a failure"
      _showTestOutput
    else
      th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
    fi
  done <<EOF
one       1
zero_eq_1 [ 0 -eq 1 ]
null
EOF

  desc='true_with_message'
  if (assertTrue 'some message' 0 >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi
}

testAssertFalse() {
  # False values.
  while read -r desc value; do
    if (assertFalse "${value}" >"${stdoutF}" 2>"${stderrF}"); then
      th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
    else
      fail "${desc}: unexpected failure"
      _showTestOutput
    fi
  done <<EOF
one       1
zero_eq_1 [ 0 -eq 1 ]
null
EOF

  # Not true values.
  while read -r desc value; do
    if (assertFalse "${value}" >"${stdoutF}" 2>"${stderrF}"); then
      fail "${desc}: expected a failure"
      _showTestOutput
    else
      th_assertFalseWithOutput "${desc}" $? "${stdoutF}" "${stderrF}"
    fi
  done <<'EOF'
zero         0
zero_eq_zero [ 0 -eq 0 ]
EOF

  desc='false_with_message'
  if (assertFalse 'some message' 1 >"${stdoutF}" 2>"${stderrF}"); then
    th_assertTrueWithNoOutput "${desc}" $? "${stdoutF}" "${stderrF}"
  else
    fail "${desc}: unexpected failure"
    _showTestOutput
  fi
}

FUNCTIONS='
assertEquals assertNotEquals
assertSame assertNotSame
assertContains assertNotContains
assertNull assertNotNull
assertTrue assertFalse
'

testTooFewArguments() {
  for fn in ${FUNCTIONS}; do
    # These functions support zero arguments.
    case "${fn}" in
      assertNull) continue ;;
      assertNotNull) continue ;;
    esac

    desc="${fn}"
    if (${fn} >"${stdoutF}" 2>"${stderrF}"); then
      fail "${desc}: expected a failure"
      _showTestOutput
    else
      got=$? want=${SHUNIT_ERROR}
      assertEquals "${desc}: incorrect return code" "${got}" "${want}"
      th_assertFalseWithError "${desc}" "${got}" "${stdoutF}" "${stderrF}"
    fi
  done
}

testTooManyArguments() {
  for fn in ${FUNCTIONS}; do
    desc="${fn}"
    if (${fn} arg1 arg2 arg3 arg4 >"${stdoutF}" 2>"${stderrF}"); then
      fail "${desc}: expected a failure"
      _showTestOutput
    else
      got=$? want=${SHUNIT_ERROR}
      assertEquals "${desc}: incorrect return code" "${got}" "${want}"
      th_assertFalseWithError "${desc}" "${got}" "${stdoutF}" "${stderrF}"
    fi
  done
}

testAssertFileExists() {
  ( assertFileExists "$TH_EXISTING_FILE" >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'file exists' $? "${stdoutF}" "${stderrF}"

  ( assertFileExists "${MSG}" "$TH_EXISTING_FILE" >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'file exists, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertFileExists "$TH_NON_EXISTING_FILE"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithOutput 'file does not exist' $? "${stdoutF}" "${stderrF}"

  ( assertFileExists "${MSG}" "$TH_NON_EXISTING_FILE"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithOutput 'file does not exist, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertFileExists "$TH_EXISTING_DIRECTORY"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithOutput 'directory exists' $? "${stdoutF}" "${stderrF}"

  ( assertFileExists "${MSG}" "$TH_EXISTING_DIRECTORY"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithOutput 'directory exists, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertFileExists >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithError 'too few arguments' $? "${stdoutF}" "${stderrF}"

  ( assertFileExists arg1 arg2 arg3 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithError 'too many arguments' $? "${stdoutF}" "${stderrF}"
}

testAssertFileDoesNotExist() {
  ( assertFileDoesNotExist "$TH_NON_EXISTING_FILE"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'file does not exist' $? "${stdoutF}" "${stderrF}"

  ( assertFileDoesNotExist "${MSG}" "$TH_NON_EXISTING_FILE"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'file does not exist, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertFileDoesNotExist "$TH_EXISTING_FILE" >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithOutput 'file exists' $? "${stdoutF}" "${stderrF}"

  ( assertFileDoesNotExist "${MSG}" "$TH_EXISTING_FILE" >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithOutput 'file exists, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertFileDoesNotExist "$TH_EXISTING_DIRECTORY"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'directory exists' $? "${stdoutF}" "${stderrF}"

  ( assertFileDoesNotExist "${MSG}" "$TH_EXISTING_DIRECTORY"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'directory exists, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertFileDoesNotExist >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithError 'too few arguments' $? "${stdoutF}" "${stderrF}"

  ( assertFileDoesNotExist arg1 arg2 arg3 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithError 'too many arguments' $? "${stdoutF}" "${stderrF}"
}

testAssertDirectoryExists() {
  ( assertDirectoryExists "$TH_EXISTING_DIRECTORY"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'directory exists' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryExists "${MSG}" "$TH_EXISTING_DIRECTORY"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'directory exists, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryExists "$TH_NON_EXISTING_DIRECTORY"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithOutput 'directory does not exist' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryExists "${MSG}" "$TH_NON_EXISTING_DIRECTORY"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithOutput 'directory does not exist, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryExists "$TH_EXISTING_FILE" >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithOutput 'file exists' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryExists "${MSG}" "$TH_EXISTING_FILE" >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithOutput 'file exists, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryExists >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithError 'too few arguments' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryExists arg1 arg2 arg3 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithError 'too many arguments' $? "${stdoutF}" "${stderrF}"
}

testAssertDirectoryDoesNotExist() {
  ( assertDirectoryDoesNotExist "$TH_NON_EXISTING_DIRECTORY"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'directory does not exist' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryDoesNotExist "${MSG}" "$TH_NON_EXISTING_DIRECTORY"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'directory does not exist, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryDoesNotExist "$TH_EXISTING_DIRECTORY"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithOutput 'directory exists' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryDoesNotExist "${MSG}" "$TH_EXISTING_DIRECTORY"  >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithOutput 'directory exists, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryDoesNotExist "$TH_EXISTING_FILE" >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'file exists' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryDoesNotExist "${MSG}" "$TH_EXISTING_FILE" >"${stdoutF}" 2>"${stderrF}" )
  th_assertTrueWithNoOutput 'file exists, with msg' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryDoesNotExist >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithError 'too few arguments' $? "${stdoutF}" "${stderrF}"

  ( assertDirectoryDoesNotExist arg1 arg2 arg3 >"${stdoutF}" 2>"${stderrF}" )
  th_assertFalseWithError 'too many arguments' $? "${stdoutF}" "${stderrF}"
}

oneTimeSetUp() {
  th_oneTimeSetUp

  _shunit_tmpDir_="${TMPDIR:-/tmp}/shunit.$(date +%s)"
  rm -rf "${_shunit_tmpDir_}"
  mkdir "${_shunit_tmpDir_}"
  TH_EXISTING_DIRECTORY="${_shunit_tmpDir_}/this_directory_exists"
  TH_EXISTING_FILE="${_shunit_tmpDir_}/this_file_exists"
  TH_NON_EXISTING_FILE="${_shunit_tmpDir_}/this_directory_does_not_exist"
  TH_NON_EXISTING_DIRECTORY="${_shunit_tmpDir_}/this_file_does_not_exist"
  mkdir "${TH_EXISTING_DIRECTORY}"
  touch "${TH_EXISTING_FILE}"

  MSG='This is a test message'

}

# showTestOutput for the most recently run test.
_showTestOutput() { th_showOutput "${SHUNIT_FALSE}" "${stdoutF}" "${stderrF}"; }

# Load and run shunit2.
# shellcheck disable=SC2034
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. "${TH_SHUNIT}"
