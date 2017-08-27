#' Attach to an existing tmux pane.
#'
#' @param name Numeric or string indicating the name of the existing pane.
#'
#' @return A `tmuxr_pane`.
#'
#' @export
attach_pane <- function(name) {
  structure(list(name = as.character(name)), class = "tmuxr_pane")
}


#' List panes.
#'
#' @param target Name of parent session or window. If `NULL` (default), all windows are
#' listed.
#'
#' @return A list of `tmuxr_pane`s.
#'
#' @export
list_panes <- function(target = NULL) {
  args <- c("-F", "'#{session_name}:#{window_index}.#{pane_index}'")
  if (is.null(target)) {
    args <- c(args, "-a")
  } else {
    args <- c(args, "-t", target$name)
  }
  tmux_list_panes(args) %>% purrr::map(attach_pane)
}


#' Capture contents of a pane.
#'
#' @export
capture_pane <- function(target, start = NULL, end = NULL,
                         trim = FALSE, trim_top = trim, trim_bottom = trim,
                         strip_lonely_prompt = TRUE,
                         as_message = FALSE, in_viewer = FALSE) {

  args <- c("-p", "-t", target$name)

  if (!is.null(start)) args <- c(args, "-S", as.character(start))
  if (!is.null(end)) args <- c(args, "-E", as.character(end))
  if (in_viewer) args <- c(args, "-e")

  pattern <- "^$"
  if (strip_lonely_prompt) pattern <- paste0(pattern, "|", target$prompt)
  output <- trim_lines(tmux_capture_pane(args), pattern, trim_top, trim_bottom)

  if (as_message) {
    message(paste0(output, collapse = "\n"))
    invisible(target)
  } else if (in_viewer) {
    filename <- file.path(tempdir(), "tmux.html")
    system2("ansi2html", c("-s", "mint-terminal"), input = output, stdout = filename)
    viewer <- getOption("viewer")
    viewer(filename)
    invisible(target)
  } else {
    output
  }
}


#' Pipe contents of a pane to a shell command.
#'
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


#' @keywords internal
trim_lines <- function(lines, pattern = "", trim_top = FALSE, trim_bottom = FALSE) {
  if (trim_top) {
    while ((length(lines) > 0) && grepl(pattern, head(lines, 1))) lines <- tail(lines, -1)
  }

  if (trim_bottom) {
    while ((length(lines) > 0) && grepl(pattern, tail(lines, 1))) lines <- head(lines, -1)
  }
  lines
}


#' @export
print.tmuxr_pane <- function(x, ...) {
  lines <- tmux_list_panes("-a")
  status <- lines[grepl(stringr::str_interp("^${x$name}:.*$"), lines)]
  cat("tmuxr pane", status)
}
