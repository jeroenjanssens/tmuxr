#' Check whether the tmux server is running
#'
#' @export
is_running <- function() {
  tryCatch({
    list_sessions()
    TRUE
  },
  error = function(e) FALSE)
}


#' Check whether tmux is installed correctly
#'
#' @export
is_installed <- function() {
  unname(Sys.which("tmux")) != ""
}


#' Kill the tmux server
#'
#' @param silent Logical. Should a possible error be suppressed?
#'
#' @export
kill_server <- function(silent = TRUE) {
  try(tmux_command("kill-server"), silent = silent)
  invisible(NULL)
}


#' Start the tmux server
#'
#' @export
start_server <- function() {
  tmux_command("start-server")
  invisible(NULL)
}


#' Get tmux version
#'
#' @param as_numeric Logical. Should the version number be returned as a
#'   numeric (default `FALSE`)
#'
#' @export
tmux_version <- function(as_numeric = FALSE) {
  result <- processx::run("tmux", "-V",
                          error_on_status = FALSE,
                          stderr_to_stdout = TRUE)

  if (as_numeric) {
    as.numeric(stringr::str_match(result$stdout, "\\d+\\.\\d+"))
  } else {
    stringr::str_trim(result$stdout)
  }
}
