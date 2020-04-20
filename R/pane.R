#' Attach to an existing tmux pane
#'
#' @param x Numeric or string indicating the name of the existing pane.
#' @param lookup_id Logical. Should the actual id be looked up just to be safe?
#'
#' @return A `tmuxr_pane`.
#'
#' @export
attach_pane <- function(x, lookup_id = TRUE) {
  if (lookup_id) {
    id <- prop(x, "pane")
  } else {
    id <- as.character(x)
  }
  structure(list(id = id), class = c("tmuxr_pane", "tmuxr_object"))
}


#' Capture the contents of a tmux pane
#'
#' @param target A `tmuxr_session`, `tmuxr_window`, or `tmuxr_pane`.
#' @param start Numeric. First line to capture.
#' @param end Numeric. Last line to capture.
#' @param escape Logical. Include escape sequences for text and background attributes.
#' @param escape_control Logical. Also escape control characters as octal \\xxx.
#' @param join Logical. Join wrapped lines and preserve trailing spaces at each line.
#' @param cat Logical. Concatenate lines into one string.
#'
#' @export
capture_pane <- function(target, start = NULL, end = NULL, escape = FALSE,
                         escape_control = FALSE, join = FALSE, cat = FALSE) {
  flags <- c("-p", "-t", get_target(target))

  if (!is.null(start)) flags <- c(flags, "-S", as.character(start))
  if (!is.null(end)) flags <- c(flags, "-E", as.character(end))
  if (escape) flags <- c(flags, "-e")
  if (escape_control) flags <- c(flags, "-C")
  if (join) flags <- c(flags, "-J")

  output <- tmux_command("capture-pane", flags)
  if (cat) {
    paste0(output, collapse = "\n")
  } else {
    output
  }
}


#' Display a large clock
#'
#' @param target A `tmuxr_session`, `tmuxr_window`, or `tmuxr_pane`.
#'
#' @export
clock_mode <- function(target = NULL) {
  flags <- c()
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))
  invisible(tmux_command("clock-mode", flags))
}


#' List tmux panes
#'
#' @param target Parent `tmuxr_session` or `tmuxr_window`. If `NULL` (default),
#'  all windows of all sessions are listed.
#'
#' @return A list of `tmuxr_pane`s.
#'
#' @export
list_panes <- function(target = NULL) {
  flags <- c("-F", "#{pane_id}")
  if (is.null(target)) {
    flags <- c(flags, "-a")
  } else {
    flags <- c(flags, "-t", get_target(target))
  }
  lapply(tmux_command("list-panes", flags), attach_pane, lookup_id = FALSE)
}


#' Pipe contents of a tmux pane to a shell command
#'
#' @param target A `tmuxr_session`, `tmuxr_window`, or `tmuxr_pane`.
#' @param shell_command String. If `NULL`, the current pipe (if any) is closed.
#' @param stdout Logical. Connect standard input of pane to `shell_command`?
#' @param stdin Logical. Connect standard output of pane to `shell_command`?
#' @param open Logical. Only open a new pipe if no previous pipe exists.
#'
#' @export
pipe_pane <- function(target = NULL, shell_command = NULL, stdout = TRUE, stdin = FALSE, open = FALSE) {
  flags <- c()
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))

  if (tmux_version(as_numeric = TRUE) >= 2.8) {
    if (stdout) flags <- c(flags, "-O")
    if (stdin) flags <- c(flags, "-I")
  }

  if (open) flags <- c(flags, "-o")
  if (!is.null(shell_command)) {
    if (!(stdout || stdin)) stop("When opening a pipe, stdout and/or stdin must be TRUE", call. = FALSE)
    flags <- c(flags, shell_command)
  }
  tmux_command("pipe-pane", flags)
  invisible(target)
}


#' @export
print.tmuxr_pane <- function(x, ...) {
  status <- display_message(x, "#{session_name}:#{window_index}.#{pane_index}: [#{pane_width}x#{pane_height}] [history #{history_size}/#{history_limit}, #{history_bytes} bytes] #{pane_id}#{?pane_active, (active),}#{?pane_dead, (dead),}")
  cat("tmuxr pane", status)
}


#' Resize a tmux pane
#'
#' @param target A `tmuxr_pane`.
#' @param width Numeric.
#' @param height Numeric.
#'
#' @export
resize_pane <- function(target, width = NULL, height = NULL) {
  flags <- c("-t", get_target(target))

  if (!is.null(width)) flags <- c(flags, "-x", as.character(width))
  if (!is.null(height)) flags <- c(flags, "-y", as.character(height))

  tmux_command("resize-pane", flags)
  target
}
