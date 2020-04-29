library(tmuxr)

set.seed(1337)

sleep <- function(n = 0.5) {
  Sys.sleep(n)
}

type <- function(target, ..., enter = TRUE) {
  keys <- unlist(strsplit(..., split = ""))
  shift_keys <- unlist(strsplit("!@#$%^&*()\"{}<>?:~", split = "", fixed = TRUE))
  for (key in keys) {
    wait <- rgamma(1, shape = 8, rate = 128) / 5
    if (key %in% shift_keys) wait <- wait * 2
    sleep(wait)
    send_keys(target, key, literal = TRUE)
  }
  if (enter) {
    wait <- rgamma(1, shape = 6, rate = 42)
    sleep(wait)
    send_keys(target, "Enter")
  }
  sleep(0.2)
}


kill_server()

session_outer <- new_session(name = "outer", width = 114, height = 38)
sleep()

send_keys(session_outer, "export TMUX=\"\"", "Enter")
sleep(0.1)
send_keys(session_outer, "asciinema rec man/figures/tmuxr.cast --overwrite -q -c 'tmux new-session -s demo bash'", "Enter")
sleep(1)
session_demo <- attach_session("demo")
type(session_demo, "cowsay Welcome to this demonstration of tmuxr, an R package to manage tmux.")
type(session_demo, "")
type(session_demo, "# Let's get started by running R and importing the tmuxr package...")
type(session_demo, "")
type(session_demo, "R --vanilla")
sleep(1)
type(session_demo, "library(tmuxr)")
pane_r <- list_panes(session_demo)[[1]]

type(pane_r, "")
type(pane_r, "# Attach to an existing tmux session:")
type(pane_r, "session_demo <- attach_session(\"demo\")")
type(pane_r, "")
type(pane_r, "# Technical side note:")
send_keys(pane_r, "#   This R process is actually running inside session_demo,", "Enter")
send_keys(pane_r, "#   so that this recording could be scripted using tmuxr itself", "Enter")
send_keys(pane_r, "#   from another R session that you don't see.", "Enter")
type(pane_r, "")
sleep(0.5)
type(pane_r, "# Create a second pane by splitting the window:")
type(pane_r, "second_pane <- split_window(before = TRUE, size = 23, shell_command = \"bash\")")
type(pane_r, "")
type(pane_r, "# Simulate typing into a pane:")
type(pane_r, "send_keys(second_pane, \"seq 100 |\", \"Enter\")")
type(pane_r, "send_keys(second_pane, \"grep 3\", \"Enter\")")
sleep(0.5)
type(pane_r, "")
type(pane_r, "# Capture the contents of a pane as a character vector:")
type(pane_r, "capture_pane(second_pane)")
sleep(0.5)
type(pane_r, "")
type(pane_r, "# Run fullscreen processes:")
type(pane_r, "send_keys(second_pane, \"top\", \"Enter\")")
sleep(1)
type(pane_r, "")
type(pane_r, "# The possibilities are truly endless:")
type(pane_r, "split_window(second_pane, vertical = FALSE, size = 0.7, shell_command = \"nyancat\")")
sleep(1)
type(pane_r, "")
type(pane_r, "# You can use the low-level function `tmux_command()` if")
type(pane_r, "# a particular command isn't implemented yet:")
type(pane_r, "tmux_command(\"resize-pane\", \"-Z\") # zoom in")
type(pane_r, "tmux_command(\"resize-pane\", \"-Z\") # zoom out")
type(pane_r, "")
type(pane_r, "# Include control characters to capture the colors as well:")
type(pane_r, "cat(capture_pane(escape = TRUE, cat = TRUE))")
type(pane_r, "")
type(pane_r, "# There are now three panes:")
type(pane_r, "list_panes(session_demo)")
type(pane_r, "")
type(pane_r, "# Send Control-C to multiple panes:")
type(pane_r, "library(purrr)")
type(pane_r, "list_panes(session_demo) %>%")
type(pane_r, "head(2) %>%")
type(pane_r, "walk(send_keys, \"C-c\")")
type(pane_r, "kill_pane(second_pane)")
type(pane_r, "")
type(pane_r, "# That concludes this demonstration of tmuxr!")
type(pane_r, "q(\"no\")")
sleep(0.5)
kill_server()
