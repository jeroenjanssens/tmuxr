# tmuxr 0.2.0

* Added functions to change the size, layout, and style of sessions, windows, and panes.
* Added many unit tests to ensure package works with tmux version 2.1 and up.
* Replaced `system2()` calls with `processx::run()` for improved speed and stability.
* Replaced id with name to identify sessions, windows, and panes.
* Removed all but one dependency, namely {processx}.
* Removed the notion of a prompt and all `wait_*()` and derivative `send_*()` functions. This will be part of {rexpect}.
* Improved README and structure of reference.


# tmuxr 0.1.0

* Added a `NEWS.md` file to track changes to the package.
