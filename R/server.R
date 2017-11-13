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
  result <- suppressWarnings(
    system2("tmux", "list-sessions", stdout = TRUE, stderr = TRUE)
  )
  status <- attr(result, "status")
  (is.null(status) || (status == 0))
}


#' Is tmux installed?
#'
#' @export
is_installed <- function() {
  unname(Sys.which("tmux")) != ""
}
