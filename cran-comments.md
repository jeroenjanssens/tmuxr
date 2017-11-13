## Resubmission
This is a resubmission. In this version I have:

* Fixed the version number by removing the trailing ".9000".

* Fixed the Title and Description fields by enclosing the software in single
  quotes and removing the redundant "from R".

* Removed the non-standard directory found at top level.

* Added code that checks whether 'tmux' is installed. If 'tmux' is not found,
  tests won't be run. 
  
## Test environments
* Local OS X install, R 3.4.2
* Ubuntu 14.04 (on travis-ci), R 3.4.2
* Windows (on appveyor), R 3.4.2

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

## Windows support

This package requires 'tmux', which can only be installed on Windows through
'Cygwin'. It is possible to get this working, but because win-builder does 
not support 'Cygwin', we have added "OS_type: unix" to DESCRIPTION.
