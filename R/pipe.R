#' @export
pipe_pane <- function(target = NULL, shell_command = NULL, open = FALSE) {
  args <- c()

  if (!is.null(target)) {
    args <- c(args, "-t", target$name)
  }

  if (open) {
    args <- c(args, "-o")
  }

  if (!is.null(shell_command)) {
    args <- c(args, shQuote(shell_command))
  }
  tmux_pipe_pane(args)
  invisible(target)
}
