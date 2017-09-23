#! /bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# shUnit2 unit test suite runner.
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the Apache 2.0 license.
#
# Author: kate.ward@forestent.com (Kate Ward)
# https://github.com/kward/shunit2
#
# This script runs all the unit tests that can be found, and generates a nice
# report of the tests.

MY_NAME=`basename $0`
MY_PATH=`dirname $0`

PREFIX='shunit2_test_'
SHELLS='/bin/sh /bin/bash /bin/dash /bin/ksh /bin/pdksh /bin/zsh'
TESTS=''
for test in ${PREFIX}[a-z]*.sh; do
  TESTS="${TESTS} ${test}"
done

# Load common unit test functions.
. ../lib/versions
. ./shunit2_test_helpers

usage() {
  echo "usage: ${MY_NAME} [-e key=val ...] [-s shell(s)] [-t test(s)]"
}

env=''

# Process command line flags.
while getopts 'e:hs:t:' opt; do
  case ${opt} in
    e)  # set an environment variable
      key=`expr "${OPTARG}" : '\([^=]*\)='`
      val=`expr "${OPTARG}" : '[^=]*=\(.*\)'`
      if [ -z "${key}" -o -z "${val}" ]; then
        usage
        exit 1
      fi
      eval "${key}='${val}'"
      export ${key}
      env="${env:+${env} }${key}"
      ;;
    h) usage; exit 0 ;;  # Output help.
    s) shells=${OPTARG} ;;  # List of shells to run.
    t) tests=${OPTARG} ;;  # List of tests to run.
    *) usage; exit 1 ;;
  esac
done
shift `expr ${OPTIND} - 1`

# Fill shells and/or tests.
shells=${shells:-${SHELLS}}
tests=${tests:-${TESTS}}

# Error checking.
if [ -z "${tests}" ]; then
  th_error 'no tests found to run; exiting'
  exit 1
fi

cat <<EOF
#------------------------------------------------------------------------------
# System data
#

# Test run info.
shells: ${shells}
tests: ${tests}
EOF
for key in ${env}; do
  eval "echo \"${key}=\$${key}\""
done
echo

# Output system data.
echo "# System info."
echo "$ date"
date
echo

echo "$ uname -mprsv"
uname -mprsv

#
# Run tests.
#

for shell in ${shells}; do
  echo

  # Check for existence of shell.
  if [ ! -x ${shell} ]; then
    th_warn "unable to run tests with the ${shell} shell"
    continue
  fi

  cat <<EOF

#------------------------------------------------------------------------------
# Running the test suite with ${shell}.
#
EOF

  SHUNIT_SHELL=${shell}  # Pass shell onto tests.
  shell_name=`basename ${shell}`
  shell_version=`versions_shellVersion "${shell}"`

  echo "shell name: ${shell_name}"
  echo "shell version: ${shell_version}"

  # Execute the tests.
  for suite in ${tests}; do
    suiteName=`expr "${suite}" : "${PREFIX}\(.*\).sh"`
    echo
    echo "--- Executing the '${suiteName}' test suite ---"
    ( unset SHELL && exec ${shell} ./${suite} 2>&1; )
  done
done
