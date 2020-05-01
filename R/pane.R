#' Attach to an existing tmux pane
#'
#' @param x An integer or string indicating the name of an existing pane.
#' @param lookup_id A logical. If `FALSE`, `x` is assumed to be a pane id.
#'   Default: `TRUE`.
#'
#' @return A tmuxr_pane.
#'
#' @export
attach_pane <- function(x, lookup_id = TRUE) {
  if (lookup_id) {
    id <- prop(x, "pane_id")
  } else {
    id <- as.character(x)
  }

  structure(list(id = id), class = c("tmuxr_pane", "tmuxr_object"))
}


#' Capture the contents of a tmux pane
#'
#' @param target A tmuxr_session, tmuxr_window, or tmuxr_pane. If `NULL`,
#'   the currently active pane is used. Default: `NULL`.
#' @param start,end An integer or a dash (`-`). First and last lines to
#'   capture. `0` is the first line of the visible pane and negative integers
#'   are lines in the history. A dash (`-`) for `start` is the start of the
#'   history and to `end` the end of the visible pane. The default is to
#'   capture only the visible contents of the pane.
#' @param escape A logical. If `TRUE`, include escape sequences for text and
#'   background attributes. Default: `FALSE`.
#' @param escape_control A logical. If `TRUE`, also escape control characters
#'   as octal \\xxx. Default: `FALSE`.
#' @param join A logical. If `TRUE`, join wrapped lines and preserve trailing
#'   spaces at each line. Default: `FALSE`.
#' @param cat A logical. If `TRUE`, concatenate lines into one string.
#'   Default: `FALSE`.
#'
#' @return A vector of strings or one string when `cat` is `TRUE`.
#'
#' @seealso [send_keys()]
#'
#' @export
capture_pane <- function(target = NULL,
                         start = NULL,
                         end = NULL,
                         escape = FALSE,
                         escape_control = FALSE,
                         join = FALSE,
                         cat = FALSE) {
  flags <- c("-p")
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))
  if (!is.null(start)) flags <- c(flags, "-S", start)
  if (!is.null(end)) flags <- c(flags, "-E", end)
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
#' @param target A tmuxr_session, tmuxr_window, or tmuxr_pane. If `NULL`, the
#'   currently active pane is used. Default: `NULL`.
#'
#' @export
clock_mode <- function(target = NULL) {
  flags <- c()
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))

  tmux_command("clock-mode", flags)
  invisible(target)
}


#' Kill a tmux pane
#'
#' Destroy the given pane. If no panes remain in the containing window, it is
#'   also destroyed.
#'
#' @param target A tmuxr_pane. If `NULL`, the currently active pane is used.
#'   Default: `NULL`.
#' @param inverse A logical. If `TRUE`, kills all but the `target` pane.
#'   Default: `FALSE`.
#'
#' @export
kill_pane <- function(target = NULL, inverse = FALSE) {
  flags <- c()
  if (inverse) flags <- c("-a", flags)
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))

  tmux_command("kill-pane", flags)
  invisible(NULL)
}


#' List tmux panes
#'
#' @param target A tmuxr_session or tmuxr_window. The parent session or
#'   window. If `NULL` all panes of all sessions are listed. Default: `NULL`.
#'
#' @return A list of tmuxr_panes.
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
#' @param target A tmuxr_session, tmuxr_window, or tmuxr_pane.
#' @param shell_command String. If `NULL`, the current pipe (if any) is closed.
#'   Default: `NULL`.
#' @param stdout Logical. Connect standard output of pane to `shell_command`?
#'   Default: `TRUE`.
#' @param stdin Logical. Connect standard input of pane to `shell_command`?
#'   Default: `FALSE`.
#' @param open Logical. Only open a new pipe if no previous pipe exists.
#'   Default: `FALSE`.
#'
#' @export
pipe_pane <- function(target = NULL,
                      shell_command = NULL,
                      stdout = TRUE,
                      stdin = FALSE,
                      open = FALSE) {
  flags <- c()
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))

  if (tmux_version() < 2.8) {
    if (stdin) {
      stop("Connecting standard input of a pane is not supported ",
           "for tmux version < 2.8.", call. = FALSE)
    }
  } else {
    if (stdout) flags <- c(flags, "-O")
    if (stdin) flags <- c(flags, "-I")
  }

  if (open) flags <- c(flags, "-o")
  if (!is.null(shell_command)) {
    if (!(stdout || stdin)) {
      stop("When opening a pipe, stdout and/or stdin must be TRUE",
           call. = FALSE)
    }
    flags <- c(flags, shell_command)
  }

  tmux_command("pipe-pane", flags)
  invisible(target)
}


#' @export
print.tmuxr_pane <- function(x, ...) {
  status <- display_message(x, "#{session_name}:#{window_index}.#{pane_index}: [#{pane_width}x#{pane_height}] [history #{history_size}/#{history_limit}, #{history_bytes} bytes] #{pane_id}#{?pane_active, (active),}#{?pane_dead, (dead),}")
  cat("tmuxr pane", status, "\n")
}


#' Resize a tmux pane
#'
#' @param target A tmuxr_pane.
#' @param width An integer. Default: `NULL`.
#' @param height An integer. Default: `NULL`.
#'
#' @export
resize_pane <- function(target, width = NULL, height = NULL) {
  flags <- c("-t", get_target(target))
  if (!is.null(width)) flags <- c(flags, "-x", as.character(width))
  if (!is.null(height)) flags <- c(flags, "-y", as.character(height))

  tmux_command("resize-pane", flags)
  invisible(target)
}


#' Create a new tmux pane
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
new_pane <- function(target = NULL,
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
