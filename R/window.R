#' @export
window_from_name <- function(name) {
  structure(list(name = name), class = "tmuxr_window")
}


#' @export
tmux_list_windows <- tmux_command("list-windows")
list_windows <- function(target = NULL) {
  args <- c("-F", "'#{session_name}:#{window_index}'")
  if (is.null(target)) {
    args <- c(args, "-a")
  } else {
    args <- c(args, "-t", target$name)
  }
  tmux_list_windows(args) %>% purrr::map(window_from_name)
}


#' @export
print.tmuxr_window <- function(x, ...) {
  lines <- tmux_list_windows("-a")
  status <- lines[grepl(stringr::str_interp("^${x$name}:.*$"), lines)]
  cat("tmuxr window", status)
}
