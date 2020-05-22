## This version (0.2.4) fixes an issue related to testing

* Fixed that the temporary socket file would be deleted after testing.


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
* GitHub Actions:
    * Ubuntu 16.04
        * R-release
        * R-devel
        * R-oldrel
    * macOS
        * R-release
        * R-devel


## R CMD check results

0 errors | 0 warnings | 0 notes


## Reverse dependencies

This package has no reverse dependencies.


## Windows support

This package does not support Windows. The reasons is that this package depends
on tmux, which can only runs on Windows through something like Cygwin or WSL.
