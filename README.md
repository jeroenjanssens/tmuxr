
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tmuxr <img src="man/figures/logo.png" align="right" width="100px" />

[![Travis-CI build
status](https://travis-ci.org/datascienceworkshops/tmuxr.svg?branch=master)](https://travis-ci.org/datascienceworkshops/tmuxr)
[![codecov](https://codecov.io/gh/datascienceworkshops/tmuxr/branch/master/graph/badge.svg)](https://codecov.io/gh/datascienceworkshops/tmuxr)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/tmuxr)](https://cran.r-project.org/package=tmuxr)

## Overview

`tmuxr` is an R package that allows you to manage
[tmux](https://github.com/tmux/tmux/wiki) and interact with the
processes it runs. It features a pipeable API with which you can create,
control, and capture tmux sessions, windows, and panes.

## Installation

The development version of `tmuxr` can be installed with:

``` r
# install.packages("remotes")
remotes::install_github("datascienceworkshops/tmuxr")
```

## A demonstration

To get an idea of what `tmuxr` has to offer, consider the following
example, where we run two different versions of R in order to compare
the output of the function `t.test()`. It’s perhaps a bit contrived, but
it allows us to demonstrate the various capabilities of `tmuxr`.

Let’s create a tmux session that runs a local version of R.

``` r
library(tmuxr)
s <- new_session(name = "demo", shell_command = "R --vanilla", height = 13)
```

We don’t see anything—because a session starts in detached mode by
default—but there’s now a pane with a size of 80 by 13 with which we can
interact.

``` r
(p <- select_pane_active(s))
#> tmuxr pane demo:0.0: [80x13] [history 7/2000, 2224 bytes] %0 (active)
```

With the `send_keys()` function, we can simulate typing into that pane.
To verify that this works, we can use the `capture_pane()` function to
take a “screenshot”.

``` r
send_keys(p, "pi", "Enter")
cat(capture_pane(p, cat = TRUE))
#>   Natural language support but running in an English locale
#> 
#> R is a collaborative project with many contributors.
#> Type 'contributors()' for more information and
#> 'citation()' on how to cite R or R packages in publications.
#> 
#> Type 'demo()' for some demos, 'help()' for on-line help, or
#> 'help.start()' for an HTML browser interface to help.
#> Type 'q()' to quit R.
#> 
#> > pi
#> [1] 3.141593
#> >
```

That seems to work, so let’s continue by creating a new pane that runs a
different version of R using Docker. Notice that both panes now have a
height of 6 lines because the window was split vertically.

``` r
p2 <- split_window(s, shell_command = "docker run --rm -it rocker/r-ver:3.1.0")
name(p2) <- "r-3.1"
list_panes()
#> [[1]]
#> tmuxr pane demo:0.0: [80x6] [history 16/2000, 4912 bytes] %0 
#> 
#> [[2]]
#> tmuxr pane demo:0.1: [80x6] [history 0/2000, 0 bytes] %1 (active)
```

With `purrr::map`, we can interact with multiple panes in parallel.
Here, we run the `t.test()` function with some dummy data and inspect
the standard error of the mean.

``` r
purrr::map(list_panes(), send_keys,
           "(result <- t.test(1:10, y = c(7:20)))", "Enter",
           "result$stderr", "Enter")
#> [[1]]
#> tmuxr pane demo:0.0: [80x6] [history 32/2000, 8224 bytes] %0 
#> 
#> [[2]]
#> tmuxr pane demo:0.1: [80x6] [history 14/2000, 4448 bytes] %1 (active)
Sys.sleep(0.5)

cat(capture_pane(p, cat = TRUE))
#> mean of x mean of y
#>       5.5      13.5
#> 
#> > result$stderr
#> [1] 1.47196
#> >

cat(capture_pane(p2, cat = TRUE))
#> mean of x mean of y
#>       5.5      13.5
#> 
#> > result$stderr
#> NULL
#> >
```

Indeed, in R version 3.1, `t.test()` does not return the standard error.
Finally, we can kill the tmux server, which also stops both the local R
process and the Docker container.

``` r
kill_server()
```

And that concludes our demonstration. Note that tmux (and, as a result
`tmuxr`) can run any process that runs in a terminal, not just R. Please
have a look at [the reference](reference/) to learn more about what
`tmuxr` has to offer.

## Compatibility

We [regularly test](https://travis-ci.org/datascienceworkshops/tmuxr)
`tmuxr` on Ubuntu with tmux versions 2.1 through 3.1 and on macOS with
the latest version of tmux provided by Homebrew. `tmuxr` might work on
Windows using Cygwin or WSL, but we haven’t tested this.

## License

The `tmuxr` package is licensed under the MIT License.
