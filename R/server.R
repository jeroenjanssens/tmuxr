#' Kill the tmux server.
#'
#' @export
kill_server <- function(silent = TRUE) {
  try(tmux_command("kill-server"), silent = silent)
  invisible(NULL)
}


#' Start the tmux server.
#'
#' @export
start_server <- function() {
  tmux_command("start-server")
  invisible(NULL)
}


#' Is the tmux server running?
#'
#' @export
is_running <- function() {
  tryCatch(
    {
      list_sessions()
      TRUE
    },
    error = function(e) FALSE
  )
}


#' Is tmux correctly installed?
#'
#' @export
is_installed <- function() {
  unname(Sys.which("tmux")) != ""
}
