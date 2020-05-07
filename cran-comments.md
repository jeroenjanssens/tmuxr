## This version (0.2.3) fixes issues related to examples and tests

* Ensured tests are being skipped when the tmux binary is not found (cf. Section 1.6 of "Writing R Extensions").
* Made tests more robust by giving tmux more time to call external tools.
* Marked all example code with \dontrun{}.
* Added tmux versions 2.9a, 3.1a, and 3.1b to both Travis-CI and R-CMD-check on GitHub Actions.


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
