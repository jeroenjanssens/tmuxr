#' Attach to an existing tmux window.
#'
#' @param name Numeric or string indicating the name of the existing window.
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
  structure(list(id = id), class = c("tmuxr_object", "tmuxr_window"))
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
  flags <- c("-F", "#{window_id}")
  if (is.null(target)) {
    flags <- c(flags, "-a")
  } else {
    flags <- c(flags, "-t", get_target(target))
  }
  tmux_command("list-windows", flags) %>% purrr::map(attach_window, lookup_id = FALSE)
}


#' Resize a window
#'
#' @param target A session or window.
#' @param width Numeric.
#' @param height Numeric.
#'
#' @export
resize_window <- function(target, width = NULL, height = NULL) {
  flags <- c("-t", get_target(target))

  if (!is.null(width)) flags <- c(flags, "-x", as.character(width))
  if (!is.null(height)) flags <- c(flags, "-y", as.character(height))

  tmux_command("resize-window", flags)
  target
}


#' Rename a window
#'
#' @param target A `tmuxr_window`.
#' @param new_name String indicating the new name of the session
#'
#' @return A `tmuxr_window`.
#'
#' @export
rename_window <- function(target, new_name) {
  tmux_command("rename-window", "-t", get_target(target),
               as.character(new_name))
  target
}


#' @export
print.tmuxr_window <- function(x, ...) {
  status <- display_message(x, "#{session_name}:#{window_index}: #{window_name}#{window_flags} (#{window_panes} panes) [#{window_width}x#{window_height}] [layout #{window_layout}] #{window_id}#{?window_active, (active),}")
  cat("tmuxr window", status)
}
