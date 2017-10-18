#! /bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# This script runs the provided unit tests and sends the output to the
# appropriate file.
#
# Copyright 2008-2017 Kate Ward. All Rights Reserved.
# Released under the Apache 2.0 license.
#
# Author: kate.ward@forestent.com (Kate Ward)
# https://github.com/kward/shunit2
#
# Source following.
#   shellcheck disable=SC1090,SC1091
# FLAGS variables are dynamically created.
#   shellcheck disable=SC2154
# Disagree with [ p ] && [ q ] vs [ p -a -q ] recommendation.
#   shellcheck disable=SC2166

# Treat unset variables as an error.
set -u

die() {
  [ $# -gt 0 ] && echo "error: $*" >&2
  exit 1
}

BASE_DIR=$(dirname "$0")
LIB_DIR="${BASE_DIR}/lib"

### Load libraries.
. "${LIB_DIR}/shflags" || die 'unable to load shflags library'
. "${LIB_DIR}/shlib" || die 'unable to load shlib library'
. "${LIB_DIR}/versions" || die 'unable to load versions library'

# Redefining BASE_DIR now that we have the shlib functions. We need BASE_DIR so
# that we can properly load things, even in the event that this script is called
# from a different directory.
BASE_DIR=$(shlib_relToAbsPath "${BASE_DIR}")

# Define flags.
os_name=$(versions_osName |sed 's/ /_/g')
os_version=$(versions_osVersion)

DEFINE_boolean force false 'force overwrite' f
DEFINE_string output_dir "${TMPDIR}" 'output dir' d
DEFINE_string output_file "${os_name}-${os_version}.txt" 'output file' o
DEFINE_string runner 'test_runner' 'unit test runner' r
DEFINE_boolean dry_run false "suppress logging to a file" n

main() {
  # Determine output filename.
  # shellcheck disable=SC2154
  output="${FLAGS_output_dir:+${FLAGS_output_dir}/}${FLAGS_output_file}"
  output=$(shlib_relToAbsPath "${output}")

  # Checks.
  if [ "${FLAGS_dry_run}" -eq "${FLAGS_FALSE}" -a -f "${output}" ]; then
    if [ "${FLAGS_force}" -eq "${FLAGS_TRUE}" ]; then
      rm -f "${output}"
    else
      echo "not overwriting '${output}'" >&2
      exit "${FLAGS_ERROR}"
    fi
  fi
  if [ "${FLAGS_dry_run}" -eq "${FLAGS_FALSE}" ]; then
    touch "${output}" 2>/dev/null || die "unable to write to '${output}'"
  fi

  # Run tests.
  (
    if [ "${FLAGS_dry_run}" -eq "${FLAGS_FALSE}" ]; then
      "./${FLAGS_runner}" |tee "${output}"
    else
      "./${FLAGS_runner}"
    fi
  )

  if [ "${FLAGS_dry_run}" -eq "${FLAGS_FALSE}" ]; then
    echo >&2
    echo "Output written to '${output}'." >&2
  fi
}

FLAGS "$@" || exit $?
[ "${FLAGS_help}" -eq "${FLAGS_FALSE}" ] || exit
eval set -- "${FLAGS_ARGV}"
main "${@:-}"
