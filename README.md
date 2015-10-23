#### Abstract
shUnit2 is a [xUnit](http://en.wikipedia.org/wiki/XUnit) unit test framework for Bourne based shell scripts, and it is designed to work in a similar manner to [JUnit](http://www.junit.org/), [PyUnit](http://pyunit.sourceforge.net/), etc.. If you have ever had the desire to write a unit test for a shell script, shUnit2 can do the job.

#### Introduction
shUnit2 was originally developed to provide a consistent testing solution for [log4sh](http://log4sh.sourceforge.net/), a shell based logging framework similar to [log4j](http://logging.apache.org/). During the development of that product, a repeated problem of having things work just fine under one shell (`/bin/bash` on Linux to be specific), and then not working under another shell (`/bin/sh` on Solaris) kept coming up. Although several simple tests were run, they were not adequate and did not catch some corner cases. The decision was finally made to write a proper unit test framework after multiple brown-bag releases were made. _Research was done to look for an existing product that met the testing requirements, but no adequate product was found._

Tested Operating Systems (varies over time)

* Cygwin
* FreeBSD (user supported)
* Linux (Gentoo, Ubuntu)
* Mac OS X
* Solaris 8, 9, 10 (inc. OpenSolaris)

Tested Shells

* Bourne Shell (__sh__)
* BASH - GNU Bourne Again SHell (__bash__)
* DASH (__dash__)
* Korn Shell (__ksh__)
* pdksh - Public Domain Korn Shell (__pdksh__)
* zsh - Zsh (__zsh__) (since 2.1.2) _please see the Zsh shell errata for more information_

See the appropriate Release Notes for this release (`doc/RELEASE_NOTES-X.X.X.txt`) for the list of actual versions tested.

#### Credits / Contributors
A list of contributors to shUnit2 can be found in the source archive in `doc/contributors.txt`. Many thanks go out to all those who have contributed to make this a better tool.

shUnit2 is the original product of many hours of work by Kate Ward, the primary author of the code. For other products by her, look up [log4sh](http://log4sh.sourceforge.net/) or [shFlags](http://shflags.googlecode.com/), or visit her website at http://forestent.com/.

#### Feedback
Feedback is most certainly welcome for this document. Send your additions, comments and criticisms to the shunit2-users@google.com mailing list.

#### Quickstart
This section will give a very quick start to running unit tests with shUnit2. More information is located in later sections.

Here is a quick sample script to show how easy it is to write a unit test in shell. _Note: the script as it stands expects that you are running it from the "examples" directory._

    #! /bin/sh
    # file: examples/equality_test.sh
    
    testEquality()
    {
      assertEquals 1 1
    }
    
    # load shunit2
    . ../src/shell/shunit2

Running the unit test should give results similar to the following.

    testEquality
    
    Ran 1 test.
    
    OK

W00t! You've just run your first successful unit test. So, what just happened? Quite a bit really, and it all happened simply by sourcing the `shunit2` library. The basic functionality for the script above goes like this:


* When shUnit2 is sourced, it will walk through any functions defined whose namestart with the string `test` and add those to an internal list of tests to execute. Once a list of test functions to be run has been determined, shunit2 will go to work.
* Before any tests are executed, shUnit2 again looks for a function, this time one named `oneTimeSetUp()`. If it exists, it will be run. This function is normally used to setup the environment for all tests to be run. Things like creating directories for output or setting environment variables are good to place here. Just so you know, you can also declare a corresponding function named `oneTimeTearDown()` function that does the same thing, but once all the tests have been completed. It is good for removing temporary directories, etc.
* shUnit2 is now ready to run tests. Before doing so though, it again looks for another function that might be declared, one named `setUp()`. If the function exists, it will be run before each test. It is good for resetting the environment so that each test starts with a clean slate. At this stage, the first test is finally run. The success of the test is recorded for a report that will be generated later. After the test is run, shUnit2 looks for a final function that might be declared, one named `tearDown()`. If it exists, it will be run after each test. It is a good place for cleaning up after each test, maybe doing things like removing files that were created, or removing directories. This set of steps, `setUp() > test() > tearDown()`, is repeated for all of the available tests.
* Once all the work is done, shUnit2 will generate the nice report you saw above. A summary of all the successes and failures will be given so that you know how well your code is doing.

We should now try adding a test that fails. Change your unit test to look like this.
