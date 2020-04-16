#' @keywords internal
tmux_command <- function(command, ...) {
  stopifnot(rlang::is_scalar_character(command))

  suppressWarnings(
    result <- system2("tmux", c(command, ...), stdout = TRUE, stderr = TRUE)
  )

  status <- attr(result, "status")
  if (!is.null(status) && (status > 0)) {
    stop(stringr::str_c("tmux: ", result, collapse = " "))
  }
  result
}

