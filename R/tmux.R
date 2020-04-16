#' @keywords internal
tmux_command <- function(command, ...) {
  stopifnot(rlang::is_scalar_character(command))

  tmux_args <- c(
    "-f", getOption("tmux_config_file", "/dev/null")
    )

  suppressWarnings(
    result <- system2("tmux", c(tmux_args, command, ...), stdout = TRUE, stderr = TRUE)
  )

  status <- attr(result, "status")
  if (!is.null(status) && (status > 0)) {
    stop(stringr::str_c("tmux: ", result, collapse = " "))
  }
  result
}

