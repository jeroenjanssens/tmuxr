#' Send keys to a tmux pane
#'
#' @param target A tmuxr_session, tmuxr_window, or tmuxr_pane. If `NULL`,
#'   the currently active pane is used. Default: `NULL`.
#' @param ... Strings. Keys to send.
#' @param literal A logical. If `TRUE`, key name lookup is disabled and the keys
#'   are processed as literal UTF-8 characters. Default: `FALSE`.
#' @param count An integer. Number of times the keys are sent. Default: `1L`.
#'
#' @seealso [capture_pane()]
#'
#' @examples
#' s <- new_session(shell_command = "cat")
#' send_keys(s, "Speak", "Space", "friend")
#' send_keys(s, "BSpace", count = 6L)
#' send_keys(s, "mellon and ")
#' send_keys(s, "enter", "!", literal = TRUE)
#' send_keys(s, "enter", literal = FALSE)
#' capture_pane(s, start = 0L, end = 1L)
#' kill_session(s)
#'
#' @export
send_keys <- function(target = NULL, ..., literal = FALSE, count = 1L) {
  flags <- c()
  if (literal) flags <- c(flags, "-l")
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))

  if (tmux_version() < 2.4) {
    flags <- c(flags, ...)
    for (i in seq(count)) tmux_command("send-keys", flags)
  } else {
    flags <- c(flags, "-N", count, ...)
    tmux_command("send-keys", flags)
  }

  invisible(target)
}


#' Send prefix to a tmux pane
#'
#' @param target A tmuxr_session, tmuxr_window, or tmuxr_pane. If `NULL`,
#'   the currently active pane is used. Default: `NULL`.
#' @param secondary A logical. If `TRUE`, send secondary prefix. Default:
#'   `NULL`.
#' @export
send_prefix <- function(target = NULL, secondary = FALSE) {
  flags <- c()
  if (secondary) flags <- c(flags, "-2")
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))

  tmux_command("send-prefix", flags)
  invisible(target)
}
