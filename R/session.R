#' Create a new tmux session.
#'
#' @param name String to be used as session name. If `NULL` (default), the
#' name of the session is determined by `tmux`, which is the next unused
#' integer (starting at 0).
#' @param window_name String to be used as window name.
#' @param start_directory String. Working directory this session is run in.
#' @param width Numeric. Width of inital window. Default 80
#' characters.
#' @param height Numeric. Height of initial window. Default 24
#' lines. By default, `tmux` uses one status line, so the effective height
#' is decreased by one line.
#' @param detached Logical. Default `TRUE`. If `FALSE`, the `R` interpreter
#' waits for the session to be killed.
#' @param shell_command String. System command to be invoked when creating the
#' session.
#'
#' @return A `tmuxr_session`.
#'
#' @export
new_session <- function(name = NULL,
                        window_name = NULL,
                        start_directory = NULL,
                        width = 80,
                        height = 24,
                        detached = TRUE,
                        shell_command = NULL) {

  flags <- c("-P", "-F", "#{session_name}")
  if (detached) flags <- c(flags, "-d")
  if (!is.null(name)) flags <- c(flags, "-s", name)
  if (!is.null(window_name)) flags <- c(flags, "-n", window_name)
  if (!is.null(start_directory)) flags <- c(flags, "-c", start_directory)
  if (!is.null(width)) flags <- c(flags, "-x", width)
  if (!is.null(height)) flags <- c(flags, "-y", height)
  if (!is.null(shell_command)) flags <- c(flags, shQuote(shell_command))

  name <- tmux_command("new-session", flags)
  attach_session(name)
}


#' Attach to an existing tmux session.
#'
#' @param name Numeric or string indicating the name of the existing session.
#' @param prompt String containing a regular expression.
#'
#' @return A `tmuxr_session`.
#'
#' @export
attach_session <- function(name) {
  structure(list(name = as.character(name)), class = "tmuxr_session")
}


#' Rename a session.
#'
#' @param session A `tmuxr_session`.
#' @param new_name String indicating the new name of the session
#'
#' @return A `tmuxr_session`.
#'
#' @export
rename_session <- function(session, new_name) {
  tmux_command("rename-session", "-t", session$name, as.character(new_name))
  attach_session(new_name)
}


#' Kill a session.
#'
#' @param session A `tmuxr_session`.
#'
#' @export
kill_session <- function(session) {
  tmux_command("kill-session", "-t", session$name)
  invisible(NULL)
}


#' List sessions.
#'
#' @return A list of `tmuxr_session`s.
#'
#' @export
list_sessions <- function() {
  flags <- c("-F", "#{session_name}")
  tmux_command("list-sessions", flags) %>% purrr::map(attach_session)
}


#' @export
print.tmuxr_session <- function(x, ...) {
  lines <- tmux_command("list-sessions")
  status <- lines[grepl(stringr::str_interp("^${x$name}:.*$"), lines)]
  cat("tmuxr session", status)
}
