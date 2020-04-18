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


#' Get tmux version.
#'
#' @export
tmux_version <- function(as_numeric = FALSE) {
  result <- processx::run("tmux", "-V", error_on_status = FALSE, stderr_to_stdout = TRUE)

  if (as_numeric) {
    as.numeric(stringr::str_match(result$stdout, "\\d+\\.\\d+"))
  } else {
    stringr::str_trim(result$stdout)
  }
}
