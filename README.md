
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
    ## [5] "$ date"                        "Mon Jul 24 22:21:51 CEST 2017"

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
  send_keys("q") %>%
  kill_session()
```

    ## 1  [|||||||||                    21.9%] Tasks: 281, 643 thr, 0 kthr; 1 running
    ## 2  [|||                           7.3%] Load average: 1.45 1.44 1.36
    ## 3  [|||||||||                    21.3%] Uptime: 1 day, 01:26:48
    ## 4  [|||                           6.7%]
    ## Mem[||||||||||||           4.60G/16.0G]
    ## Swp[|||||||                 184M/1.00G]
    ##   PID USER      PRI  NI  VIRT   RES S CPU% MEM%   TIME+  Command
    ##  3060 jeroen     17   0 4010M  389M ? 30.2  2.4  8:04.45 RStudio /Users/jeroen/r
    ##   331 jeroen     17   0 2579M 13040 ?  3.4  0.1  0:08.87 Finder
    ##   585 jeroen     24   0  828M 74716 ?  1.3  0.4  1:03.14 Adobe Desktop Service -
    ## 13539 jeroen     17   0 2419M 12700 ?  0.8  0.1  0:00.06 mdworker -s mdworker -c
    ##   536 jeroen     17   0  674M  6116 ?  0.6  0.0  0:12.59 AdobeIPCBroker -launche
    ##   568 jeroen     17   0 2437M  3880 ?  0.6  0.0  0:23.68 AdobeCRDaemon 486 Creat
    ##  6238 jeroen     24   0 2681M  130M ?  0.3  0.8  0:12.99 rsession --config-file
    ##   593 jeroen     24   0 2597M 13796 ?  0.2  0.1  0:41.62 Core Sync
    ## 13636 jeroen     24   0 2387M  1616 R  0.2  0.0  0:00.01 htop
    ##   594 jeroen     24   0 3097M 12508 ?  0.1  0.1  0:10.14 node /Applications/Util
    ##   306 jeroen     17   0 2415M  2068 ?  0.1  0.0  0:02.42 cfprefsd agent
    ##   962 jeroen     17   0 2687M 44812 ?  0.1  0.3  0:33.09 iTerm2
    ##   610 jeroen     24   0 3066M 15888 ?  0.1  0.1  0:03.33 node /Applications/Util
    ##   465 jeroen     17   0 2412M  2072 ?  0.0  0.0  0:09.42 karabiner_console_user_
    ## 13612 jeroen     24   0 2397M  1244 ?  0.0  0.0  0:00.00 tmux new-session -P -F
    ## F1Help  F2Setup F3SearchF4FilterF5Tree  F6SortByF7Nice -F8Nice +F9Kill  F10Quit

#### Jupyter console

``` r
jupyter <- new_session(shell_command = "jupyter console",
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
jupyter %>%
  wait(0.1) %>%
  send_lines("mysum(41, 1)") %>%
  wait(0.1) %>%
  capture_pane(start = 18, as_message = TRUE) %>%
  kill_session()
```

    ## In [2]: mysum(41, 1)
    ## Out[2]: 42
    ## 
    ## In [3]:

### License

The `tmuxr` package is licensed under the GPLv3 (<http://www.gnu.org/licenses/gpl.html>).
