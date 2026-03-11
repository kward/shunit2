# Coding Standards

shUnit2 is more than just a simple 20-line shell script. It is a significant
library of shell code that at first glance is not easy to understand. To improve
code readability and usability, we've established guidelines to make the code
more understandable for anyone who wants to read or modify it.

## Function declaration

Declare functions using the following form:
```sh
doSomething() {
  echo 'done!'
}
```

One-line functions are allowed if they can fit within the 80-character line
limit.

```sh
doSomething() { echo 'done!'; }
```

## Function documentation
Each function should be preceded by a header that provides the following:

1. A one-sentence summary of what the function does.

2. (optional) A longer description of what the function does, and perhaps some
   special information that helps convey its usage better.

3. Args: a one-line summary of each argument of the form:

   `name: type: description`

4. Output: a one-line summary of the output provided. Only output to STDOUT must
   be documented, unless the output to STDERR is of significance (i.e. not just
   an error message). The output should be of the form:

   `type: description`

5. Returns: a one-line summary of the value returned. Returns in shell are
   always integers, but if the output is a true/false for success (i.e. a
   boolean), it should be noted. The output should be of the form:

   `type: description`

Here is a sample header:
```sh
# Records a test failure, stating two values were not equal.
#
# This is functionally equivalent to calling failNotEquals().
#
# Args:
#   message: string: failure message [optional]
#   expected: string: expected value
#   actual: string: actual value
# Returns:
#   integer: success (TRUE/FALSE/ERROR constant)
```

## Variable and function names

All shUnit2 specific constants, variables, and functions will be prefixed
appropriately with 'shunit'. This is to distinguish usage in the shUnit2 code
from users' own scripts so that the shell name space remains predictable to
users. The exceptions here are the standard `assertEquals`, etc. functions.

All non built-in constants and variables will be surrounded with squiggle
brackets, e.g. `${shunit_someVariable}` to improve code readability.

Due to some shells not supporting local variables in functions, care in the
naming and use of variables, both public and private, is very important.
Accidental overriding of the variables can occur easily if care is not taken as
all variables are technically global variables in some shells.

Type                             | Sample
-------------------------------- | ------
global public constant           | `SHUNIT_TRUE`
global private constant          | `__SHUNIT_BUILTIN`
global public variable           | `shunit_variable`
global private variable          | `__shunit_variable`
global macro                     | `_SHUNIT_SOME_MACRO_`
public function                  | `shunit_function`
public function, local variable  | `shunit_variable_`
private function                 | `_shunit_function`
private function, local variable | `_shunit_variable_`

Where it makes sense to improve readability, variables can have the first
letter of the second and later words capitalized. For example, the local
variable name for the help string length is `shunit_someVar_`.

There is one special-case global public variable used. It is used to
overcome the limitations of shell scoping or to prevent forking. The variable is:

- `shunit_return`

## Local variable cleanup

As many shells do not support local variables, no support for cleanup of
variables is present either. As such, all variables local to a function must be
cleared up with the `unset` built-in command at the end of each function.

## Indentation

Code block indentation is two (2) spaces, and tabs must not be used.

```sh
if [ -z 'some string' ]; then
  someFunction
fi
```

Lines of code should be no longer than 80 characters unless absolutely
necessary. When lines are wrapped using the backslash character '\', subsequent
lines should be indented with four (4) spaces so as to differentiate from the
standard spacing of two characters, and tabs must not be used.

```sh
for x in some set of very long set of arguments that make for a very long \
    that extends much too long for one line
do
  echo ${x}
done
```

When a conditional expression is written using the built-in [ command, and that
line must be wrapped, place the control || or && operators on the same line as
the expression where possible, with the list to be executed on its own line.

```sh
[ -n 'some really long expression' -a -n 'some other long expr' ] && \
    echo 'that was actually true!'
```
