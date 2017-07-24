#' @export
pane_from_name <- function(name) {
  structure(list(name = name), class = "tmuxr_pane")
}


#' @export
list_panes <- function(target = NULL) {
  args <- c("-F", "'#{session_name}:#{window_index}.#{pane_index}'")
  if (is.null(target)) {
    args <- c(args, "-a")
  } else {
    args <- c(args, "-t", target$name)
  }
  tmux_list_panes(args) %>% purrr::map(pane_from_name)
}

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


#' @export
print.tmuxr_pane <- function(x, ...) {
  lines <- tmux_list_panes("-a")
  status <- lines[grepl(stringr::str_interp("^${x$name}:.*$"), lines)]
  cat("tmuxr pane", status)
}

