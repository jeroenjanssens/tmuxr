#' @keywords internal
tmux_command <- function(command, ...) {
  stopifnot(rlang::is_scalar_character(command))

  tmux_options <- c()

  if (!is.null(getOption("tmux_config_file")))
    tmux_options <- c(tmux_options, "-f", getOption("tmux_config_file"))

  if (!is.null(getOption("tmux_socket_name")))
    tmux_options <- c(tmux_options, "-L", getOption("tmux_socket_name"))

  if (!is.null(getOption("tmux_socket_path")))
    tmux_options <- c(tmux_options, "-S", getOption("tmux_socket_path"))

  suppressWarnings(
    result <- system2("tmux", c(tmux_options, command, ...),
                      stdout = TRUE, stderr = TRUE)
  )

  status <- attr(result, "status")
  if (!is.null(status) && (status > 0)) {
    stop(stringr::str_c("tmux: ", result, collapse = " "))
  }
  result
}
