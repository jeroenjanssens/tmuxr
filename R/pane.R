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
  args <- c("-F", "'#{session_name}:#{window_index}.#{pane_index}'")
  if (is.null(target)) {
    args <- c(args, "-a")
  } else {
    args <- c(args, "-t", target$name)
  }
  tmux_list_panes(args) %>% purrr::map(attach_pane)
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
  args <- c("-p", "-t", target$name)

  if (!is.null(start)) args <- c(args, "-S", as.character(start))
  if (!is.null(end)) args <- c(args, "-E", as.character(end))
  if (escape) args <- c(args, "-e")
  if (escape_control) args <- c(args, "-C")
  if (join) args <- c(args, "-J")

  output <- tmux_capture_pane(args)
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
  args <- c()

  if (!is.null(target)) {
    args <- c(args, "-t", target$name)
  }

  if (open) {
    args <- c(args, "-o")
  }

  if (!is.null(shell_command)) {
    args <- c(args, shQuote(shell_command))
  }
  tmux_pipe_pane(args)
  invisible(target)
}


#' @export
print.tmuxr_pane <- function(x, ...) {
  lines <- tmux_list_panes("-a")
  status <- lines[grepl(stringr::str_interp("^${x$name}:.*$"), lines)]
  cat("tmuxr pane", status)
}


#' Get height of pane
#'
#' @param target A session, window, or pane.
#'
#' @export
get_height <- function(target) {
  args <- c("-p", "-t", target$name, "'#{pane_height}'")
  as.numeric(tmux_display(args))
}


#' Get width of pane
#'
#' @param target A session, window, or pane.
#'
#' @export
get_width <- function(target) {
  args <- c("-p", "-t", target$name, "'#{pane_width}'")
  as.numeric(tmux_display(args))
}


