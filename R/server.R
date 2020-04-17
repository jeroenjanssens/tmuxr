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
  tryCatch({tmuxr::list_sessions(); TRUE}, error = function(cond) {FALSE})
}


#' Is tmux correctly installed?
#'
#' @export
is_installed <- function() {
  unname(Sys.which("tmux")) != ""
}
