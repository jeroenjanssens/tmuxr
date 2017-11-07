#' Create a new tmux session.
#'
#' @param name String to be used as session name. If `NULL` (default), the
#' name of the session is determined by `tmux`, which is the next unused
#' integer (starting at 0).
#' @param prompt String containing a regular expression that matches all
#' relevant prompts.
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
                        prompt = NULL,
                        window_name = NULL,
                        start_directory = NULL,
                        width = 80,
                        height = 24,
                        detached = TRUE,
                        shell_command = NULL) {

  args <- c("-P", "-F", "\"#{session_name}\"")
  if (detached) args <- c(args, "-d")
  if (!is.null(name)) args <- c(args, "-s", name)
  if (!is.null(window_name)) args <- c(args, "-n", window_name)
  if (!is.null(start_directory)) args <- c(args, "-n", start_directory)
  if (!is.null(width)) args <- c(args, "-x", width)
  if (!is.null(height)) args <- c(args, "-y", height)
  if (!is.null(shell_command)) args <- c(args, shQuote(shell_command))

  name <- tmux_new_session(args)
  attach_session(name, prompt)
}


#' Attach to an existing tmux session.
#'
#' @param name Numeric or string indicating the name of the existing session.
#' @param prompt String containing a regular expression.
#'
#' @return A `tmuxr_session`.
#'
#' @export
attach_session <- function(name, prompt = NULL) {
  structure(list(name = as.character(name),
                 prompt = prompt),
            class = "tmuxr_session")
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
  tmux_rename_session("-t", session$name, as.character(new_name))
  attach_session(new_name)
}


#' Kill a session.
#'
#' @param session A `tmuxr_session`.
#'
#' @export
kill_session <- function(session) {
  tmux_kill_session("-t", session$name)
  invisible(NULL)
}


#' List sessions.
#'
#' @return A list of `tmuxr_session`s.
#'
#' @export
list_sessions <- function() {
  args <- c("-F", "'#{session_name}'")
  tmux_list_sessions(args) %>% purrr::map(attach_session)
}


#' @export
print.tmuxr_session <- function(x, ...) {
  lines <- tmux_list_sessions()
  status <- lines[grepl(stringr::str_interp("^${x$name}:.*$"), lines)]
  cat("tmuxr session", status)
}
