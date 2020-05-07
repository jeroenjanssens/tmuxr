# tmuxr 0.2.3

* Ensured tests are being skipped when the tmux binary is not found (cf. Section 1.6 of "Writing R Extensions").
* Made tests more robust by giving tmux more time to call external tools.
* Marked all example code with \dontrun{}.
* Added tmux versions 2.9a, 3.1a, and 3.1b to both Travis-CI and R-CMD-check on GitHub Actions.

# tmuxr 0.2.2

* Added functions to change the size, layout, and style of sessions, windows, and panes.
* Added many unit tests to ensure package works with tmux version 2.1 and up.
* Replaced `system2()` calls with `processx::run()` for improved speed and stability.
* Replaced id with name to identify sessions, windows, and panes.
* Removed all but one dependency, namely {processx}.
* Removed the notion of a prompt and all `wait_*()` and derivative `send_*()` functions. This will be part of {rexpect}.
* Improved README and structure of reference.


# tmuxr 0.1.0

* Added a `NEWS.md` file to track changes to the package.
