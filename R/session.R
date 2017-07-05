#' @export
session_from_name <- function(name) {
  structure(list(name = name), class = "tmuxr_session")
}


#' @export
new_session <- function(name = NULL,
                        window_name = NULL,
                        start_directory = NULL,
                        width = NULL,
                        height = NULL,
                        detached = TRUE,
                        shell_command = NULL) {

  args <- c("-P", "-F", "\"#{session_name}\"")
  if (detached) args <- c(args, "-d")
  if (!is.null(name)) args <- c(args, "-s", name)
  if (!is.null(window_name)) args <- c(args, "-n", window_name)
  if (!is.null(start_directory)) args <- c(args, "-n", start_directory)
  if (!is.null(width)) args <- c(args, "-x", width)
  if (!is.null(height)) args <- c(args, "-y", height)
  if (!is.null(shell_command)) args <- c(args, shQuote(shell_command))

  name <- tmux_new_session(args)
  session_from_name(name)
}


#' @export
list_sessions <- function() {
  args <- c("-F", "'#{session_name}'")
  tmux_list_sessions(args) %>% purrr::map(session_from_name)
}


#' @export
rename_session <- function(session, new_name) {
  tmux_rename_session("-t", session$name, new_name)
  session_from_name(new_name)
}


#' @export
kill_session <- function(session) {
  tmux_kill_session("-t", session$name)
}


#' @export
print.tmuxr_session <- function(x, ...) {
  lines <- tmux_list_sessions()
  status <- lines[grepl(stringr::str_interp("^${x$name}:.*$"), lines)]
  cat("tmuxr session", status)
}
