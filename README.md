
<!-- README.md is generated from README.Rmd. Please edit that file -->
tmuxr <img src="man/figures/logo.png" align="right" width="100px" />
====================================================================

[![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/jw0bf2mt65q556ec/branch/master?svg=true)](https://ci.appveyor.com/project/jeroenjanssens/tmuxr/branch/master) [![Travis-CI build status](https://travis-ci.org/datascienceworkshops/tmuxr.svg?branch=master)](https://travis-ci.org/datascienceworkshops/tmuxr) [![codecov](https://codecov.io/gh/datascienceworkshops/tmuxr/branch/master/graph/badge.svg)](https://codecov.io/gh/datascienceworkshops/tmuxr) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/tmuxr)](https://cran.r-project.org/package=tmuxr)

Overview
--------

`tmuxr` is an R package that allows you (1) to manage [tmux](https://github.com/tmux/tmux/wiki) and (2) to interact with the processes it runs. It features a pipeable API with which you can create, control, and capture tmux sessions, windows, and panes.

Most functions, such as `new_session`, `list_windows`, and `send_keys` are inspired by the commands `tmux` offers. Other functions, such as `attach_window`, `wait_for_prompt`, `send_lines` are added for convenience. Please note that not all `tmux` commands have yet been implemented.

Installation
------------

You can install `tmuxr` from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("datascienceworkshops/tmuxr")
```

Examples
--------

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
#> [1] "$ seq 100 |"                  "> grep 3 |"                  
#> [3] "> wc -l"                      "      19"                    
#> [5] "$ date"                       "Thu Nov  9 13:35:52 CET 2017"
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
#>  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=C
#>  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base
#> 
#> other attached packages:
#> [1] dplyr_0.7.2     purrr_0.2.2.2   readr_1.1.1     tidyr_0.6.3
#> [5] tibble_1.3.3    ggplot2_2.2.1   tidyverse_1.1.1
#> 
#> loaded via a namespace (and not attached):
#>  [1] Rcpp_0.12.12     cellranger_1.1.0 compiler_3.4.1   plyr_1.8.4
#>  [5] bindr_0.1        forcats_0.2.0    tools_3.4.1      jsonlite_1.5
#>  [9] lubridate_1.6.0  nlme_3.1-131     gtable_0.2.0     lattice_0.20-35
#> [13] pkgconfig_2.0.1  rlang_0.1.1      psych_1.7.5      parallel_3.4.1
#> [17] haven_1.1.0      bindrcpp_0.2     xml2_1.1.1       stringr_1.2.0
#> [21] httr_1.2.1       hms_0.3          grid_3.4.1       glue_1.1.1
#> [25] R6_2.2.2         readxl_1.0.0     foreign_0.8-69   reshape2_1.4.2
#> [29] modelr_0.1.1     magrittr_1.5     scales_0.4.1     rvest_0.3.2
#> [33] assertthat_0.2.0 mnormt_1.5-5     colorspace_1.3-2 stringi_1.1.5
#> [37] lazyeval_0.2.0   munsell_0.4.3    broom_0.4.2
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
#> Jupyter console 5.1.0
#> 
#> Python 3.6.1 |Anaconda 4.4.0 (x86_64)| (default, May 11 2017, 13:04:09)
#> Type "copyright", "credits" or "license" for more information.
#> 
#> IPython 5.3.0 -- An enhanced Interactive Python.
#> ?         -> Introduction and overview of IPython's features.
#> %quickref -> Quick reference.
#> help      -> Python's own help system.
#> object?   -> Details about 'object', use 'object??' for extra details.
#> 
#> 
#> 
#> In [1]: def mysum(a, b):
#>       :     return a + b
#>       :
#>       :
```

<!-- ### Capture a telnet session -->
<!-- ```{r, cache=TRUE} -->
<!-- new_session(shell_command = "telnet", prompt = "^telnet>$") %>% -->
<!--   send_keys("open towel.blinkenlights.nl") %>% -->
<!--   send_enter() %>% -->
<!--   wait(26) %>% -->
<!--   capture_pane(as_message = TRUE, trim = FALSE) %>% -->
<!--   kill_session() -->
<!-- ``` -->
### Continue with an existing session

``` r
attach_session("python", prompt = prompts$jupyter) %>%
  wait(0.2) %>%
  send_lines("mysum(41, 1)") %>%
  wait(0.2) %>%
  capture_pane(start = 18, as_message = TRUE)
#> In [2]: mysum(41, 1)
#> Out[2]: 42
#> 
#> In [3]:
```

``` r
list_sessions()
#> [[1]]
#> tmuxr session docker_R: 1 windows (created Thu Nov  9 13:35:52 2017) [80x24]
#> [[2]]
#> tmuxr session python: 1 windows (created Thu Nov  9 13:35:54 2017) [80x24]
kill_server()
#> character(0)
```

License
-------

The `tmuxr` package is licensed under the MIT License.
