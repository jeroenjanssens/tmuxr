#' Identifier of a tmux object
#'
#' @param target A tmuxr_session, tmuxr_window, or tmuxr_pane.
#' @return A string.
#' @export
id <- function(target) {
  target$id
}


#' Is tmux object active?
#'
#' @param target A tmuxr_window or tmuxr_pane.
#' @return A logical.
#' @export
is_active <- function(target) {
  UseMethod("is_active")
}


#' @export
is_active.tmuxr_window <- function(target) {
  prop(target, "window_active") == "1"
}


#' @export
is_active.tmuxr_pane <- function(target) {
  prop(target, "pane_active") == "1"
}


#' Index of a tmux object
#'
#' @param target A tmuxr_window or tmuxr_pane.
#' @return An integer.
#' @export
index <- function(target) {
  UseMethod("index")
}


#' @export
index.tmuxr_window <- function(target) {
  as.numeric(prop(target, "window_index"))
}


#' @export
index.tmuxr_pane <- function(target) {
  as.numeric(prop(target, "pane_index"))
}
