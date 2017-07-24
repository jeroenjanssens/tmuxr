
<!-- README.md is generated from README.Rmd. Please edit that file -->
tmuxr
=====

The `tmuxr` package allows you to control [tmux](https://github.com/tmux/tmux/wiki) from R.

### Installation

You can install `tmuxr` from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("datascienceworkshops/tmuxr")
```

### Examples

``` r
library(tmuxr)
```

#### Bash

``` r
s <- new_session(shell_command = "PS1='$ ' bash")
wait_for_prompt(s)
send_lines(s, c("seq 100 |",
                "grep 3 |",
                "wc -l ",
                "date"))
capture_pane(s, trim = TRUE)
```

    ## [1] "$ seq 100 |"                   "> grep 3 |"                   
    ## [3] "> wc -l"                       "      19"                     
    ## [5] "$ date"                        "Mon Jul 24 22:43:23 CEST 2017"

``` r
kill_session(s)
```

#### Full screen capture

``` r
new_session() %>%
  send_keys("htop") %>%
  send_enter() %>%
  wait(2) %>%
  capture_pane(as_message = TRUE) %>%
  send_keys("q")
```

    ## 1  [||||||                       14.6%] Tasks: 296, 680 thr, 0 kthr; 1 running
    ## 2  [||                            2.0%] Load average: 1.37 1.88 1.69
    ## 3  [|||||                        10.7%] Uptime: 1 day, 01:48:20
    ## 4  [||                            2.0%]
    ## Mem[||||||||||||||||||||   6.23G/16.0G]
    ## Swp[||||                    120M/1.00G]
    ##   PID USER      PRI  NI  VIRT   RES S CPU% MEM%   TIME+  Command
    ##  3060 jeroen     17   0 4072M  454M ? 10.7  2.8  9:04.43 RStudio /Users/jeroen/r
    ##   331 jeroen     17   0 2579M 13076 ?  1.7  0.1  0:09.79 Finder
    ## 13331 jeroen     17   0 2448M 44392 ?  0.7  0.3  0:00.36 mdworker -s mdworker -c
    ##  6238 jeroen     24   0 2681M  130M ?  0.3  0.8  0:16.09 rsession --config-file
    ## 14348 jeroen     17   0 5827M  326M ?  0.3  2.0  1:57.53 Chromium Helper --type=
    ## 13920 jeroen     24   0 2443M 14744 ?  0.2  0.1  0:01.16 syncdefaultsd
    ##   593 jeroen     24   0 2597M 13856 ?  0.1  0.1  0:42.93 Core Sync
    ##   597 jeroen     17   0 2411M  1908 ?  0.1  0.0  0:26.15 AdobeCRDaemon 593 Core
    ## 19047 jeroen     24   0 2387M  1676 R  0.1  0.0  0:00.01 htop
    ##   590 jeroen     17   0 2411M  1908 ?  0.1  0.0  0:26.19 AdobeCRDaemon 585 Adobe
    ##   566 jeroen     17   0 4310M  162M ?  0.0  1.0  4:18.30 Chromium Helper --type=
    ## 19023 jeroen     24   0 2405M  1300 ?  0.0  0.0  0:00.00 tmux new-session -P -F
    ##   465 jeroen     17   0 2412M  2164 ?  0.0  0.0  0:09.72 karabiner_console_user_
    ##   962 jeroen     17   0 2687M 44836 ?  0.0  0.3  0:33.20 iTerm2
    ##   374 jeroen     24   0 2447M 11004 ?  0.0  0.1  0:06.77 sharingd
    ## F1Help  F2Setup F3SearchF4FilterF5Tree  F6SortByF7Nice -F8Nice +F9Kill  F10Quit

#### Jupyter console

``` r
jupyter <- new_session(name = "python",
                       shell_command = "jupyter console",
                       prompt = prompts$jupyter)

jupyter$prompt
```

    ## [1] "^(In \\[[0-9]+\\]| {6,})|$"

``` r
jupyter %>%
  wait_for_prompt() %>%
  send_lines(c("def mysum(a, b):",
               "return a + b",
               "",
               "")) %>%
  capture_pane(as_message = TRUE, strip_lonely_prompt = FALSE, trim = TRUE)
```

    ## Jupyter console 5.1.0
    ## 
    ## Python 3.6.1 |Anaconda 4.4.0 (x86_64)| (default, May 11 2017, 13:04:09)
    ## Type "copyright", "credits" or "license" for more information.
    ## 
    ## IPython 5.3.0 -- An enhanced Interactive Python.
    ## ?         -> Introduction and overview of IPython's features.
    ## %quickref -> Quick reference.
    ## help      -> Python's own help system.
    ## object?   -> Details about 'object', use 'object??' for extra details.
    ## 
    ## 
    ## 
    ## In [1]: def mysum(a, b):
    ##       :     return a + b
    ##       :
    ##       :

#### Telnet

``` r
new_session(shell_command = "telnet", prompt = "^telnet>$") %>%
  send_keys("open towel.blinkenlights.nl") %>%
  send_enter() %>%
  wait(26) %>%
  capture_pane(as_message = TRUE) %>%
  kill_session()
```

    ## 
    ## 
    ## 
    ## 
    ## 
    ## 
    ## 
    ##                           8888888888  888    88888
    ##                          88     88   88 88   88  88
    ##                           8888  88  88   88  88888
    ##                              88 88 888888888 88   88
    ##                       88888888  88 88     88 88    888888
    ## 
    ##                       88  88  88   888    88888    888888
    ##                       88  88  88  88 88   88  88  88
    ##                       88 8888 88 88   88  88888    8888
    ##                        888  888 888888888 88   88     88
    ##                         88  88  88     88 88    8888888

#### Continue with earlier session

``` r
session_from_name("python", prompt = prompts$jupyter) %>%
  wait(0.2) %>%
  send_lines("mysum(41, 1)") %>%
  wait(0.2) %>%
  capture_pane(start = 18, as_message = TRUE)
```

    ## In [2]: mysum(41, 1)
    ## Out[2]: 42
    ## 
    ## In [3]:

``` r
list_sessions()
```

    ## [[1]]
    ## tmuxr session 0: 1 windows (created Mon Jul 24 22:43:23 2017) [80x23]
    ## [[2]]
    ## tmuxr session python: 1 windows (created Mon Jul 24 22:43:25 2017) [80x23]

``` r
kill_server()
```

    ## character(0)

### License

The `tmuxr` package is licensed under the GPLv3 (<http://www.gnu.org/licenses/gpl.html>).
