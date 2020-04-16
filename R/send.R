#' Send keys to a session, window, or pane.
#'
#' @param target A session, window, or pane.
#' @param keys String to send.
#' @param literal Should the keys be interpreted literally?
#'
#' @export
send_keys <- function(target, keys, literal = FALSE) {
  args <- c("-t", target$name)
  if (literal) args <- c(args, "-l")
  args <- c(args, shQuote(keys))
  tmux_send_keys(args)
  invisible(target)
}


#' Sleep.
#'
#' @param target A session, window, or pane.
#' @param time Numerical. Time to sleep in seconds.

#' @export
sleep <- function(target, time) {
  Sys.sleep(time)
  invisible(target)
}
