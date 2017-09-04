#' Kill the tmux server.
#'
#' @export
kill_server <- function() {
  tmux_kill_server()
}


#' Start the tmux server.
#'
#' @export
start_server <- function() {
  tmux_start_server()
}

#' Is the tmux server running?
#'
#' @export
is_running <- function() {
  pids <- suppressWarnings(system2("pgrep", c("-x", "tmux"),
                                   stdout = TRUE, stderr = FALSE))
  length(pids) > 0
}
