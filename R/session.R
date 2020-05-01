#' Attach to an existing tmux session
#'
#' @param x An integer or string indicating the name of an existing window.
#' @param lookup_id A logical. If `FALSE`, `x` is assumed to be a session id.
#'   Default: `TRUE`.
#'
#' @return A tmuxr_session.
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
#' @param target A tmuxr_session.
#' @param inverse A logical. If `TRUE`, kills all but the `target` session.
#'   Default: `FALSE`.
#'
#' @export
kill_session <- function(target, inverse = FALSE) {
  flags <- c("-t", get_target(target))
  if (inverse) flags <- c("-a", flags)

  tmux_command("kill-session", flags)
  invisible(NULL)
}


#' List tmux sessions
#'
#' @return A list of tmuxr_sessions.
#'
#' @export
list_sessions <- function() {
  flags <- c("-F", "#{session_id}")
  lapply(tmux_command("list-sessions", flags),
         attach_session, lookup_id = FALSE)
}


#' Create a new tmux session
#'
#' Create a new tmux session with name `name`.
#'
#' @param name A string. Name of the session. If `NULL`, the
#'   name determined by `tmux`, which is the next unused integer
#'   (by default starting at 0). Default: `NULL`.
#' @param window_name A string. Name of initial window.
#' @param start_directory A string. Working directory this session is run in.
#' @param width An integer. Width of initial window. Default: 80.
#' @param height An integer. Height of initial window. Default: 24.
#' @param detached A logical. If `FALSE`, the `R` interpreter
#'   waits for the session to be killed. Default: `TRUE`.
#' @param shell_command A string. Shell command to be invoked when creating the
#'   session.
#'
#' @note
#' Prior to tmux version 2.6, the actual height is one line less than `height`.
#'
#' @return A tmuxr_session.
#' @examples
#' s <- new_session("foo", shell_command = "bash", height = 10)
#' list_sessions()
#' kill_session(s)
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
  cat("tmuxr session", status, "\n")
}


#' Rename a tmux session
#'
#' @param target A tmuxr_session.
#' @param value String indicating the new name of the session.
#'
#' @return A tmuxr_session.
#'
#' @export
rename_session <- function(target, value) {
  # For some reason, tmux version 2.7 returns an error regardless of whether
  # the session gets renamed successfully, so set .silent to TRUE.
  tmux_command("rename-session", "-t", get_target(target),
               as.character(value), .silent = tmux_version() == 2.7)
  invisible(target)
}
