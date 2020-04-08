
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tmuxr <img src="man/figures/logo.png" align="right" width="100px" />

[![Travis-CI build
status](https://travis-ci.org/datascienceworkshops/tmuxr.svg?branch=master)](https://travis-ci.org/datascienceworkshops/tmuxr)
[![AppVeyor Build
status](https://ci.appveyor.com/api/projects/status/jw0bf2mt65q556ec/branch/master?svg=true)](https://ci.appveyor.com/project/jeroenjanssens/tmuxr/branch/master)
[![codecov](https://codecov.io/gh/datascienceworkshops/tmuxr/branch/master/graph/badge.svg)](https://codecov.io/gh/datascienceworkshops/tmuxr)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

## Overview

`tmuxr` is an R package that allows you (1) to manage
[tmux](https://github.com/tmux/tmux/wiki) and (2) to interact with the
processes it runs. It features a pipeable API with which you can create,
control, and capture tmux sessions, windows, and panes.

Most functions, such as `new_session`, `list_windows`, and `send_keys`
are inspired by the commands `tmux` offers. Other functions, such as
`attach_window`, `wait_for_prompt`, `send_lines` are added for
convenience. Please note that not all `tmux` commands have yet been
implemented.

## Rationale

The main reason `tmuxr` exists is because of the
[knitractive](https://datascienceworkshops.github.io/knitractive/)
package. This package provides a knitr engine that allows you to
simulate interactive sessions (e.g., Python console, Bash shell) across
multiple code chunks. Interactive sessions are run inside a `tmux`
session. We realized that the functionality for managing `tmux` could be
useful in itself or as a basis for other packages as well, and hence
decided to put that functionality into its own package.

Generally speaking, `tmuxr` might be of interest to you if you want to
automate interactive applications such as `bash`, `ssh`, and
command-line interfaces. Have a look at the examples below.

## Installation

The development version of `tmuxr` from GitHub can be installed with:

``` r
# install.packages("devtools")
devtools::install_github("datascienceworkshops/tmuxr")
```

## Examples

``` r
library(tmuxr)
```

### Bash

``` r
s <- new_session(shell_command = "PS1='$ ' bash",
                 prompt = prompts$bash)
wait_for_prompt(s)
send_lines(s, c("seq 100 |",
                "grep 3 |",
                "wc -l ",
                "date"))
capture_pane(s, trim = TRUE)
#> [1] "$ seq 100 |"                   "> grep 3 |"                   
#> [3] "> wc -l"                       "      19"                     
#> [5] "$ date"                        "Wed Apr  8 14:21:48 CEST 2020"
kill_session(s)
```

<!-- #### Full screen capture -->

<!-- ```{r} -->

<!-- new_session() %>% -->

<!--   send_keys("htop") %>% -->

<!--   send_enter() %>% -->

<!--   wait(2) %>% -->

<!--   capture_pane(as_message = TRUE) %>% -->

<!--   send_keys("q") -->

<!-- ``` -->

### Run R via Docker

``` r
new_session(shell_command = "docker run --rm -it rocker/tidyverse R",
            prompt = prompts$R,
            name = "docker_R") %>%
  send_lines(c("library(tidyverse)",
               "sessionInfo()")) %>%
  capture_pane(as_message = TRUE)
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base
#> 
#> other attached packages:
#> [1] forcats_0.4.0   stringr_1.4.0   dplyr_0.8.3     purrr_0.3.3
#> [5] readr_1.3.1     tidyr_1.0.2     tibble_2.1.3    ggplot2_3.2.1
#> [9] tidyverse_1.3.0
#> 
#> loaded via a namespace (and not attached):
#>  [1] Rcpp_1.0.3       cellranger_1.1.0 pillar_1.4.3     compiler_3.6.2
#>  [5] dbplyr_1.4.2     tools_3.6.2      jsonlite_1.6     lubridate_1.7.4
#>  [9] lifecycle_0.1.0  nlme_3.1-142     gtable_0.3.0     lattice_0.20-38
#> [13] pkgconfig_2.0.3  rlang_0.4.4      reprex_0.3.0     cli_2.0.1
#> [17] rstudioapi_0.10  DBI_1.1.0        haven_2.2.0      withr_2.1.2
#> [21] xml2_1.2.2       httr_1.4.1       fs_1.3.1         generics_0.0.2
#> [25] vctrs_0.2.2      hms_0.5.3        grid_3.6.2       tidyselect_1.0.0
#> [29] glue_1.3.1       R6_2.4.1         fansi_0.4.1      readxl_1.3.1
#> [33] modelr_0.1.5     magrittr_1.5     backports_1.1.5  scales_1.1.0
#> [37] rvest_0.3.5      assertthat_0.2.1 colorspace_1.4-1 stringi_1.4.5
#> [41] lazyeval_0.2.2   munsell_0.5.0    broom_0.5.4      crayon_1.3.4
#> >
```

### Jupyter console

``` r
jupyter <- new_session(name = "python",
                       shell_command = "jupyter console",
                       prompt = prompts$jupyter)

jupyter$prompt
#> [1] "^(In \\[[0-9]+\\]| {6,})|$"

jupyter %>%
  wait_for_prompt() %>%
  send_lines(c("def mysum(a, b):",
               "return a + b",
               "",
               "")) %>%
  capture_pane(as_message = TRUE, strip_lonely_prompt = FALSE, trim = TRUE)
#> Jupyter console 6.1.0
#> 
#> Python 3.7.6 (default, Jan  8 2020, 13:42:34)
#> Type 'copyright', 'credits' or 'license' for more information
#> IPython 7.12.0 -- An enhanced Interactive Python. Type '?' for help.
#> 
#> In [1]: def mysum(a, b):
#>       :
```

### Capture a telnet session

``` r
new_session(shell_command = "telnet", prompt = "^telnet>$") %>%
  send_keys("open towel.blinkenlights.nl") %>%
  send_enter() %>%
  wait(26) %>%
  capture_pane(as_message = TRUE, trim = FALSE) %>%
  kill_session()
#> open towel.blinkenlights.nltelnet>
#> Trying 94.142.241.111...
```

### Continue with an existing session

``` r
attach_session("python", prompt = prompts$jupyter) %>%
  wait(0.2) %>%
  send_lines("mysum(41, 1)") %>%
  wait(0.2) %>%
  capture_pane(start = 18, as_message = TRUE)
#> 
```

``` r
list_sessions()
#> [[1]]
#> tmuxr session docker_R: 1 windows (created Wed Apr  8 14:21:48 2020)
#> [[2]]
#> tmuxr session python: 1 windows (created Wed Apr  8 14:22:00 2020)
kill_server()
#> character(0)
```

## License

The `tmuxr` package is licensed under the MIT License.
