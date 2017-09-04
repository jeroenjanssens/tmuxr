#' Does the contents of a pane end with prompt?
#'
#' @param target A session, window, or pane.
#'
#' @export
ends_with_prompt <- function(target) {
  stopifnot(has_prompt(target))
  args <- c("-p", "-t", target$name)
  lines <- tmux_capture_pane(args)
  last_line <- tail(lines[lines != ""], n = 1)
  (length(last_line) > 0L) && stringr::str_detect(last_line, target$prompt)
}


#' Get the prompt pattern of a session, window or pane.
#'
#' @param target A session, window, or pane.
#' @return String containing a regular expression that matches all relevant
#' prompts.
#'
#' @export
get_prompt <- function(target) {
  target$prompt
}


#' Set the prompt pattern of a session, window or pane.
#'
#' @param target A session, window, or pane.
#' @param prompt String containing a regular expression that matches all
#' relevant prompts.
#'
#' @export
set_prompt <- function(target, prompt) {
  target$prompt <- prompt
  invisible(target)
}

#' Is there a prompt pattern associated with a session, window, or pane?
#'
#' @param target A session, window, or pane.
#'
#' @export
has_prompt <- function(target) {
  !is.null(get_prompt(target))
}


#' Wait for prompt to appear in session, window or pane.
#'
#' @param target A session, window, or pane.
#' @param time Numerical. Time to wait in seconds between tries.
#'
#' @export
wait_for_prompt <- function(target, time = 0.05) {
  stopifnot(has_prompt(target))
  while (!ends_with_prompt(target)) wait(target, time)
  invisible(target)
}


#' A list of commonly used prompt patterns.
#'
#' @export
prompts <- list(
  bash = "^(\\$|>)$",
  ipython = "^(In \\[[0-9]+\\]| {6,})|$",
  jupyter = "^(In \\[[0-9]+\\]| {6,})|$",
  python = "^(>>>|\\.\\.\\.)$",
  r = "^(>|\\+)$",
  R = "^(>|\\+)$"
)
