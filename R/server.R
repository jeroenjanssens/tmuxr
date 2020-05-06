#' Is the tmux server running?
#'
#' Check whether the tmux server is running.
#'
#' @return A logical.
#'
#' @export
is_running <- function() {
  tryCatch({
    list_sessions()
    TRUE
  },
  error = function(e) FALSE)
}


#' Is tmux installed correctly?
#'
#' Check whether tmux is installed correctly
#'
#' @return A logical.
#'
#' @export
is_installed <- function() {
  unname(Sys.which(getOption("tmux_binary", "tmux"))) != ""
}


#' Kill the tmux server
#'
#' @param silent A logical. Should a possible error be suppressed?
#'   Default: `TRUE`.
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
#' Get the version of tmux.
#'
#' @param as_numeric A logical. If `TRUE`, the version number is returned as a
#'   numeric. Default: `TRUE`.
#'
#' @return A numeric or string.
#'
#' @examples
#' \dontrun{
#' tmux_version()
#' tmux_version() >= 2.8
#' tmux_version(as_numeric = FALSE)
#' }
#'
#' @export
tmux_version <- function(as_numeric = TRUE) {
  version <- tmux_command("-V")

  if (as_numeric) {
    matches <- regexec("\\d+\\.\\d+", version)
    as.numeric(regmatches(version, matches)[[1]])
  } else {
    trimws(version)
  }
}
