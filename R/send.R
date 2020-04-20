#' Send keys to a session, window, or pane.
#'
#' @param target A `tmuxr_session`, `tmuxr_window`, or `tmuxr_pane`.
#' @param keys String to send.
#' @param literal Should the keys be interpreted literally?
#'
#' @export
send_keys <- function(target, keys, literal = FALSE) {
  flags <- c("-t", get_target(target))
  if (literal) {
    flags <- c(flags, "-l", keys)
  } else {
    flags <- c(flags, unlist(strsplit(keys, " ")))
  }
  tmux_command("send-keys", flags)
  invisible(target)
}
