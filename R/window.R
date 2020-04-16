#' Attach to an existing tmux window.
#'
#' @param name Numeric or string indicating the name of the existing window.
#'
#' @return A `tmuxr_window`.
#'
#' @export
attach_window <- function(name) {
  structure(list(name = as.character(name)), class = "tmuxr_window")
}


#' List windows.
#'
#' @param target Name of parent session. If `NULL` (default), all windows are
#' listed.
#'
#' @return A list of `tmuxr_window`s.
#'
#' @export
list_windows <- function(target = NULL) {
  flags <- c("-F", "'#{session_name}:#{window_index}'")
  if (is.null(target)) {
    flags <- c(flags, "-a")
  } else {
    flags <- c(flags, "-t", target$name)
  }
  tmux_command("list-windows", flags) %>% purrr::map(attach_window)
}

#' Resize window.
#'
#' @param target A session.
#' @param width Numeric.
#' @param height Numeric.
#'
#' @export
resize_window <- function(target, width = NULL, height = NULL) {

# TODO Implement resize_window
}



#' @export
print.tmuxr_window <- function(x, ...) {
  lines <- tmux_command("list-windows", "-a")
  # TODO Maybe replace stringr with glue?
  status <- lines[grepl(stringr::str_interp("^${x$name}:.*$"), lines)]
  cat("tmuxr window", status)
}
