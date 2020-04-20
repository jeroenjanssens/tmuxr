#' Attach to an existing tmux session
#'
#' @param x Numeric or string indicating the id or name of the existing session.
#' @param lookup_id Logical. Should the actual id be looked up just to be safe?
#'
#' @return A `tmuxr_session`.
#'
#' @export
attach_session <- function(x, lookup_id = TRUE) {
  if (lookup_id) {
    id <- prop(x, "session_id")
  } else {
    id <- as.character(x)
  }
  structure(list(id = id), class = c("tmuxr_session", "tmuxr_object"))
}


#' Kill a tmux session
#'
#' @param target A `tmuxr_session`.
#'
#' @export
kill_session <- function(target) {
  tmux_command("kill-session", "-t", get_target(target))
  invisible(NULL)
}


#' List sessions
#'
#' @return A list of `tmuxr_session`s.
#'
#' @export
list_sessions <- function() {
  flags <- c("-F", "#{session_id}")
  tmux_command("list-sessions", flags) %>% purrr::map(attach_session, lookup_id = FALSE)
}


#' Create a new tmux session
#'
#' @param name String to be used as session name. If `NULL` (default), the
#' name of the session is determined by `tmux`, which is the next unused
#' integer (starting at 0).
#' @param window_name String to be used as window name.
#' @param start_directory String. Working directory this session is run in.
#' @param width Numeric. Width of inital window. Default 80
#' characters.
#' @param height Numeric. Height of initial window. Default 24
#' lines. Prior to version 2.6, `tmux` uses one line for the status line,
#' so the effective height is decreased by one line.
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

  flags <- c("-P", "-F", "#{session_id}")
  if (detached) flags <- c(flags, "-d")
  if (!is.null(name)) flags <- c(flags, "-s", name)
  if (!is.null(window_name)) flags <- c(flags, "-n", window_name)
  if (!is.null(start_directory)) flags <- c(flags, "-c", start_directory)
  if (!is.null(width)) flags <- c(flags, "-x", width)
  if (!is.null(height)) flags <- c(flags, "-y", height)
  if (!is.null(shell_command)) flags <- c(flags, shell_command)

  id <- tmux_command("new-session", flags)
  structure(list(id = id), class = c("tmuxr_session", "tmuxr_object"))
}


#' @export
print.tmuxr_session <- function(x, ...) {
  status <- display_message(x, "#{session_name}: #{session_windows} windows (created #{t:session_created})#{?session_grouped, (group ,}#{session_group}#{?session_grouped,),}#{?session_attached, (attached),}")
  cat("tmuxr session", status)
}


#' Rename a tmux session
#'
#' @param target A `tmuxr_session`.
#' @param value String indicating the new name of the session.
#'
#' @return A `tmuxr_session`.
#'
#' @export
rename_session <- function(target, value) {
  tmux_command("rename-session", "-t", get_target(target), as.character(value))
  invisible(target)
}
