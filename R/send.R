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
  flags <- c("-N", count)
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))
  if (literal) flags <- c(flags, "-l")
  flags <- c(flags, ...)

  tmux_command("send-keys", flags)
  invisible(target)
}
