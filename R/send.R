#' @export
send_keys <- function(target, keys, literal = FALSE) {
  args <- c("-t", target$name)
  if (literal) args <- c(args, "-l")
  args <- c(args, shQuote(keys))
  tmux_send_keys(args)
  invisible(target)
}


#' @export
send_enter <- function(target) {
  tmux_send_keys("-t", target$name, "Enter")
  invisible(target)
}


#' @export
send_lines <- function(target, lines) {
  for (line in lines) {
    send_keys(target, line, literal = TRUE)
    send_enter(target)
  }
  invisible(target)
}
