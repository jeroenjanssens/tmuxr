#' Attach to an existing tmux window
#'
#' @param x Numeric or string indicating the name of the existing window.
#' @param lookup_id Logical. Should the actual id be looked up just to be safe?
#'
#' @return A `tmuxr_window`.
#'
#' @export
attach_window <- function(x, lookup_id = TRUE) {
  if (lookup_id) {
    id <- prop(x, "window_id")
  } else {
    id <- as.character(x)
  }
  structure(list(id = id), class = c("tmuxr_window", "tmuxr_object"))
}


#' List tmux windows
#'
#' @param target Name of parent `tmuxr_session`. If `NULL` (default), all
#' windows of all sessions are listed.
#'
#' @return A `list` of `tmuxr_window`s.
#'
#' @export
list_windows <- function(target = NULL) {
  flags <- c("-F", "#{window_id}")
  if (is.null(target)) {
    flags <- c(flags, "-a")
  } else {
    flags <- c(flags, "-t", get_target(target))
  }
  lapply(tmux_command("list-windows", flags), attach_window, lookup_id = FALSE)
}


#' @export
print.tmuxr_window <- function(x, ...) {
  status <- display_message(x, "#{session_name}:#{window_index}: #{window_name}#{window_flags} (#{window_panes} panes) [#{window_width}x#{window_height}] [layout #{window_layout}] #{window_id}#{?window_active, (active),}")
  cat("tmuxr window", status)
}


#' Rename a tmux window
#'
#' @param target A `tmuxr_window`.
#' @param value String indicating the new name of the window.
#'
#' @return A `tmuxr_window`.
#'
#' @export
rename_window <- function(target, value) {
  tmux_command("rename-window", "-t", get_target(target),
               as.character(value))
  invisible(target)
}


#' Resize a tmux window
#'
#' @param target A `tmuxr_session` or `tmuxr_window`.
#' @param width Numeric.
#' @param height Numeric.
#'
#' @export
resize_window <- function(target, width = NULL, height = NULL) {
  flags <- c("-t", get_target(target))

  if (!is.null(width)) flags <- c(flags, "-x", as.character(width))
  if (!is.null(height)) flags <- c(flags, "-y", as.character(height))

  tmux_command("resize-window", flags)
  invisible(target)
}
