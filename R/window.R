#' Attach to an existing tmux window
#'
#' @param x An integer or string indicating the name of an existing window.
#' @param lookup_id A logical. If `FALSE`, `x` is assumed to be a window id.
#'   Default: `TRUE`.
#'
#' @return A tmuxr_window.
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


#' Kill a tmux window
#'
#' @param target A tmuxr_window.
#' @param inverse A logical. If `TRUE`, kills all but the `target` window.
#'   Default: `FALSE`.
#'
#' @export
kill_window <- function(target, inverse = FALSE) {
  flags <- c("-t", get_target(target))
  if (inverse) flags <- c("-a", flags)

  tmux_command("kill-window", flags)
  invisible(NULL)
}


#' List tmux windows
#'
#' @param target Name of parent tmuxr_session. If `NULL` (default), all
#' windows of all sessions are listed.
#'
#' @return A list of tmuxr_windows.
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


#' Create a new tmux window
#'
#' Create a new tmux window with name `name`.
#' When the shell command completes, the window closes.
#'
#' @param target A tmuxr_session or tmuxr_window. If `NULL`, the last session
#'   is used.
#' @param name A string. Name of the window. If `NULL`, the
#'   name determined by the shell command. Default: `NULL`.
#' @param focus A logical. If `FALSE`, the session does not make the new window
#'   the current window. Default: `TRUE`.
#' @param start_directory A string. Working directory this window is run in.
#' @param shell_command A string. Shell command to be invoked when creating the
#'   window. If `NULL`, the default shell is used.
#'
#' @return A tmuxr_window.
#' @examples
#' s <- new_session()
#' new_window()
#' kill_session(s)
#'
#' @export
new_window <- function(target = NULL,
                       name = NULL,
                       focus = TRUE,
                       start_directory = NULL,
                       shell_command = NULL) {
  flags <- c("-P", "-F", "#{window_id}")
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))
  if (!focus) flags <- c(flags, "-d")
  if (!is.null(name)) flags <- c(flags, "-n", name)
  if (!is.null(start_directory)) flags <- c(flags, "-c", start_directory)
  if (!is.null(shell_command)) flags <- c(flags, shell_command)

  id <- tmux_command("new-window", flags)
  structure(list(id = id), class = c("tmuxr_window", "tmuxr_object"))
}



#' @export
print.tmuxr_window <- function(x, ...) {
  status <- display_message(x, "#{session_name}:#{window_index}: #{window_name}#{window_flags} (#{window_panes} panes) [#{window_width}x#{window_height}] [layout #{window_layout}] #{window_id}#{?window_active, (active),}")
  cat("tmuxr window", status, "\n")
}


#' Rename a tmux window
#'
#' @param target A tmuxr_window.
#' @param value String indicating the new name of the window.
#'
#' @export
rename_window <- function(target, value) {
  tmux_command("rename-window", "-t", get_target(target), as.character(value))
  invisible(target)
}


#' Resize a tmux window
#'
#' @param target A tmuxr_session or tmuxr_window.
#' @param width An integer. Default: `NULL`.
#' @param height An integer. Default: `NULL`.
#'
#' @export
resize_window <- function(target, width = NULL, height = NULL) {
  if (tmux_version() < 2.9) {
    stop("Resizing a window is not supported for tmux version < 2.9.",
         call. = FALSE)
  }

  flags <- c("-t", get_target(target))
  if (!is.null(width)) flags <- c(flags, "-x", as.character(width))
  if (!is.null(height)) flags <- c(flags, "-y", as.character(height))

  tmux_command("resize-window", flags)
  invisible(target)
}


#' Split a tmux window
#'
#' Create a new pane by splitting `target`.
#'
#' @param target A tmuxr_session, tmuxr_window, or tmuxr_pane.
#' @param vertical A logical. If `TRUE` split `target` vertically, otherwise
#'   horizontally. Default: `TRUE`.
#' @param size A numeric. The size of the new pane in lines (for vertical
#'   splits) or characters (for horizontal splits). If less than `0`, `size` is
#'   interpreted as a percentage. Default: `NULL`.
#' @param before A logical. If `TRUE`, create the new pane to the left of or
#'   above the active pane. Default: `FALSE`.
#' @param full A logical. If `TRUE`, create a new pane spanning the full window
#'   width (for vertical splits) or full window height (for horizontal splits),
#'   instead of splitting the active pane. Default: `FALSE`.
#' @param start_directory A string. Working directory this pane is run in.
#' @param shell_command A string. Shell command to be invoked when creating the
#'   pane. If `NULL`, the default shell is used.
#'
#' @return A tmuxr_pane.
#'
#' @export
split_window <- function(target = NULL,
                         vertical = TRUE,
                         size = NULL,
                         before = FALSE,
                         full = FALSE,
                         start_directory = NULL,
                         shell_command = NULL) {
  flags <- c("-P", "-F", "#{pane_id}")
  if (vertical) {
    flags <- c(flags, "-v")
  } else {
    flags <- c(flags, "-h")
  }
  if (!is.null(size) && size > 0) {
    if (size >= 1) {
      flags <- c(flags, "-l", size)
    } else {
      flags <- c(flags, "-p", round(size * 100))
    }
  }
  if (before) flags <- c(flags, "-b")
  if (full) flags <- c(flags, "-f")
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))
  if (!is.null(start_directory)) flags <- c(flags, "-c", start_directory)
  if (!is.null(shell_command)) flags <- c(flags, shell_command)

  id <- tmux_command("split-window", flags)
  structure(list(id = id), class = c("tmuxr_pane", "tmuxr_object"))
}
