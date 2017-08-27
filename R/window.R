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
  args <- c("-F", "'#{session_name}:#{window_index}'")
  if (is.null(target)) {
    args <- c(args, "-a")
  } else {
    args <- c(args, "-t", target$name)
  }
  tmux_list_windows(args) %>% purrr::map(attach_window)
}


#' @export
print.tmuxr_window <- function(x, ...) {
  lines <- tmux_list_windows("-a")
  status <- lines[grepl(stringr::str_interp("^${x$name}:.*$"), lines)]
  cat("tmuxr window", status)
}
