#' Execute a tmux command
#'
#' @param command String.
#' @param ... Character vector of command flags.
#'
#' @export
tmux_command <- function(command, ...) {
  stopifnot(rlang::is_scalar_character(command))

  tmux_options <- c()

  if (!is.null(getOption("tmux_config_file")))
    tmux_options <- c(tmux_options, "-f", getOption("tmux_config_file"))

  if (!is.null(getOption("tmux_socket_name")))
    tmux_options <- c(tmux_options, "-L", getOption("tmux_socket_name"))

  if (!is.null(getOption("tmux_socket_path")))
    tmux_options <- c(tmux_options, "-S", getOption("tmux_socket_path"))

  result <- processx::run("tmux",
                          args = c(tmux_options, command, ...),
                          error_on_status = FALSE,
                          stderr_to_stdout = TRUE,
                          echo_cmd = getOption("tmux_echo", default = FALSE))

  if (result$status > 0) stop("tmux: ", result$stdout, call. = FALSE)

  # Split standard output into lines and remove last line because it's empty
  head(stringr::str_split(result$stdout, "\n")[[1]], -1)
}
