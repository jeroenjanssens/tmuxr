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


#' Send the Enter key to a session, window or pane.
#'
#' @param target A session, window, or pane.
#'
#' @export
send_enter <- function(target) {
  tmux_send_keys("-t", target$name, "Enter")
  invisible(target)
}


#' Send the Control C combination to a session, window or pane.
#'
#' @param target A session, window, or pane.
#'
#' @export
send_control_c <- function(target) {
  tmux_send_keys("-t", target$name, "C-c")
  invisible(target)
}


#' Send the Backspace key to a session, window or pane.
#'
#' @param target A session, window, or pane.
#'
#' @export
send_backspace <- function(target) {
  tmux_send_keys("-t", target$name, "BSpace")
  invisible(target)
}


#' Send multiple lines to a session, window, or pane.
#'
#' @param target A session, window, or pane.
#'
#' @param lines A character vector.
#' @param wait Should there be waited for the prompt after sending each line?
#'
#' @export
send_lines <- function(target, lines, wait = TRUE) {
  for (line in lines) {
    send_keys(target, line, literal = TRUE)
    send_enter(target)
    if (wait) wait_for_prompt(target)
  }
  invisible(target)
}


#' Wait.
#'
#' @param target A session, window, or pane.
#' @param time Numerical. Time to wait in seconds between tries.

#' @export
wait <- function(target, time = 0.05) {
  Sys.sleep(time)
  invisible(target)
}
