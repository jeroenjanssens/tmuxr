#' Attach to an existing tmux pane.
#'
#' @param name Numeric or string indicating the name of the existing pane.
#'
#' @return A `tmuxr_pane`.
#'
#' @export
attach_pane <- function(name) {
  structure(list(name = as.character(name)), class = "tmuxr_pane")
}


#' List panes.
#'
#' @param target Parent session or window. If `NULL` (default), all windows are
#' listed.
#'
#' @return A list of `tmuxr_pane`s.
#'
#' @export
list_panes <- function(target = NULL) {
  flags <- c("-F", "'#{session_name}:#{window_index}.#{pane_index}'")
  if (is.null(target)) {
    flags <- c(flags, "-a")
  } else {
    flags <- c(flags, "-t", target$name)
  }
  tmux_command("list-panes", flags) %>% purrr::map(attach_pane)
}


#' Capture the contents of a pane.
#'
#' @param target A session, window, or pane.
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
  flags <- c("-p", "-t", target$name)

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


#' Pipe contents of a pane to a shell command.
#'
#' @param target A session, window, or pane.
#' @param shell_command String. System command to be invoked when creating the
#' session.
#' @param open Logical. Only open a new pipe if no previous pipe exists.
#'
#' @export
pipe_pane <- function(target = NULL, shell_command = NULL, open = FALSE) {
  flags <- c()

  if (!is.null(target)) {
    flags <- c(flags, "-t", target$name)
  }

  if (open) {
    flags <- c(flags, "-o")
  }

  if (!is.null(shell_command)) {
    flags <- c(flags, shQuote(shell_command))
  }
  tmux_command("pipe-pane", flags)
  invisible(target)
}


#' @export
print.tmuxr_pane <- function(x, ...) {
  lines <- tmux_command("list-panes", "-a")
  status <- lines[grepl(stringr::str_interp("^${x$name}:.*$"), lines)]
  cat("tmuxr pane", status)
}


#' Get height of pane
#'
#' @param target A session, window, or pane.
#'
#' @export
get_height <- function(target) {
  flags <- c("-p", "-t", target$name, "'#{pane_height}'")
  as.numeric(tmux_command("display", flags))
}


#' Get width of pane
#'
#' @param target A session, window, or pane.
#'
#' @export
get_width <- function(target) {
  flags <- c("-p", "-t", target$name, "'#{pane_width}'")
  as.numeric(tmux_command("display", flags))
}


#' Display a large clock.
#'
#' @param target A session, window, or pane.
#'
#' @export
clock_mode <- function(target = NULL) {
  flags <- c()
  if (!is.null(target)) flags <- c(flags, "-t", target$name)
  invisible(tmux_command("clock-mode", flags))
}
