## Resubmission (version 0.2.2)

This is a resubmission. The tests still fail on Windows, as expected (see
section "Windows support" below), but now succeed on Linux. In this version
(tmuxr 0.2.2) I have:

* Fixed a typo in DESCRIPTION.


## Resubmission (version 0.2.1)

This is a resubmission. The tests failed on Windows, which was expected (see 
section "Windows support" below), and on Linux, which was unexpected. In this
version (tmuxr 0.2.1) I have:

* Improved the tests such that the tmux server does not get killed in between 
  the tests.
* Added tmux version 3.0a to Travis-CI. This is the version used by CRAN.


## Test environments

* Local:
    * macOS
        * R 4.0.0
* Travis-CI:
    * Ubuntu 16.04
        * R-release
        * R-devel
        * R-oldrel
    * macOS
        * R-release


## R CMD check results

0 errors | 0 warnings | 0 notes


## Reverse dependencies

This package has no reverse dependencies.


## Windows support

This package does not support Windows. The reasons is that this package depends
on tmux, which can only runs on Windows through something like Cygwin or WSL.
