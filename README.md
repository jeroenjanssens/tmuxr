
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tmuxr <img src="man/figures/logo.png" align="right" width="100px" />

[![Travis-CI build
status](https://travis-ci.org/datascienceworkshops/tmuxr.svg?branch=master)](https://travis-ci.org/datascienceworkshops/tmuxr)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

## Overview

`tmuxr` is an R package that allows you (1) to manage
[tmux](https://github.com/tmux/tmux/wiki) and (2) to interact with the
processes it runs. It features a pipeable API with which you can create,
control, and capture tmux sessions, windows, and panes.

Most functions, such as `new_session`, `list_windows`, and `send_keys`
are wrappers by the commands `tmux` offers. Other functions, such as
`attach_window` and `send_lines` are added for convenience.

## Installation

The development version of `tmuxr` from GitHub can be installed with:

``` r
# install.packages("devtools")
devtools::install_github("datascienceworkshops/tmuxr")
```

## License

The `tmuxr` package is licensed under the MIT License.
