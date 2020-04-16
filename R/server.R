#' Kill the tmux server.
#'
#' @export
kill_server <- function() {
  tmux_command("kill-server")
}


#' Start the tmux server.
#'
#' @export
start_server <- function() {
  tmux_command("start-server")
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


#' Is tmux correctly installed?
#'
#' @export
is_installed <- function() {
  unname(Sys.which("tmux")) != ""
}
