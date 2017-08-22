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
send_control_c <- function(target) {
  tmux_send_keys("-t", target$name, "C-c")
  invisible(target)
}


#' @export
send_backspace <- function(target) {
  tmux_send_keys("-t", target$name, "BSpace")
  invisible(target)
}


#' @export
send_lines <- function(target, lines, wait = TRUE) {
  for (line in lines) {
    send_keys(target, line, literal = TRUE)
    send_enter(target)
    if (wait) wait_for_prompt(target)
  }
  invisible(target)
}




#' @export
wait <- function(target, time = 0.05) {
  Sys.sleep(time)
  invisible(target)
}
