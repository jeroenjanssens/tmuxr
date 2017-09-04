#' @export
kill_server <- function() {
  tmux_kill_server()
}


#' @export
start_server <- function() {
  tmux_start_server()
}

#' @export
is_running <- function() {
  pids <- suppressWarnings(system2("pgrep", c("-x", "tmux"),
                                   stdout = TRUE, stderr = FALSE))
  length(pids) > 0
}
