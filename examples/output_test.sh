#! /bin/sh

generateOutput() {
  echo 'this output went to STDOUT'
  echo 'this output went to STDERR' >&2
  return 1
}

testGenerateOutput() {
  ( generateOutput >"${stdoutF}" 2>"${stderrF}" )
  rtrn=$?

  # This test will fail because a non-zero return code was provided.
  assertTrue "the command exited with an error" ${rtrn}

  # Show the command output if the command provided a non-zero return code.
  [ ${rtrn} -eq 0 ] || showOutput

  # This test will pass because the grepped output matches.
  grep 'STDOUT' "${stdoutF}" >/dev/null
  assertTrue 'STDOUT message missing' $?

  # This test will fail because the grepped output doesn't match.
  grep 'ST[andar]DERR[or]' "${stderrF}" >/dev/null
  assertTrue 'STDERR message missing' $?

  return 0
}

showOutput() {
  # shellcheck disable=SC2166
  if [ -n "${stdoutF}" -a -s "${stdoutF}" ]; then
    echo '>>> STDOUT' >&2
    cat "${stdoutF}" >&2
    echo '<<< STDOUT' >&2
  fi
  # shellcheck disable=SC2166
  if [ -n "${stderrF}" -a -s "${stderrF}" ]; then
    echo '>>> STDERR' >&2
    cat "${stderrF}" >&2
    echo '<<< STDERR' >&2
  fi
}

oneTimeSetUp() {
  # Define global variables for command output.
  stdoutF="${SHUNIT_TMPDIR}/stdout"
  stderrF="${SHUNIT_TMPDIR}/stderr"
}

setUp() {
  # Truncate the output files.
  cp /dev/null "${stdoutF}"
  cp /dev/null "${stderrF}"
}

# Load and run shUnit2.
# shellcheck disable=SC1091
. ../shunit2
