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

  tmux_args <- c()

  if (!is.null(getOption("tmux_config_file")))
    tmux_args <- c(tmux_args, "-f", getOption("tmux_config_file"))

  if (!is.null(getOption("tmux_socket_name")))
    tmux_args <- c(tmux_args, "-L", getOption("tmux_socket_name"))

  if (!is.null(getOption("tmux_socket_path")))
    tmux_args <- c(tmux_args, "-S", getOption("tmux_socket_path"))

  result <- suppressWarnings(
    system2("tmux", tmux_args, "list-sessions", stdout = TRUE, stderr = TRUE)
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
