#' Display a message
#'
#' @param target A session, window, or pane.
#' @param message The message to display. Refer to the FORMATS section of the tmux man page for the format.
#' @param verbose Logical. Print verbose logging as the format is parsed?
#' @param stdout Logical. Print message to stardard output?
#'
#' @export
display_message <- function(target = NULL, message = NULL, verbose = FALSE, stdout = TRUE) {
  flags <- c()
  if (verbose) flags <- c(flags, "-v")
  if (stdout) flags <- c(flags, "-p")
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))
  if (!is.null(message)) flags <- c(flags, message)
  output <- tmux_command("display-message", flags)
  if (stdout) {
    output
  } else {
    invisible(NULL)
  }
}


#' @keywords internal
get_target <- function(x) {
  if (inherits(x, "tmuxr_object")) {
    x$id
  } else {
    as.character(x)
  }
}


#' @keywords internal
prop <- function(target = NULL, property) {
  message <- paste0("#{", property, "}")
  display_message(target, message)
}

#' @export
name <- function(x) UseMethod("name")

#' @export
`name<-` <- function(x, value) UseMethod("name<-")

#' @export
width <- function(x) UseMethod("width")

#' @export
`width<-` <- function(x, value) UseMethod("width<-")

#' @export
height <- function(x) UseMethod("height")

#' @export
`height<-` <- function(x, value) UseMethod("height<-")


#' Get name of session.
#'
#' @param target A session.
#'
#' @export
name.tmuxr_session <- function(x) prop(x, "session_name")


#' Get name of window.
#'
#' @param target A window.
#'
#' @export
name.tmuxr_window <- function(x) prop(x, "window_name")


#' Get name of a pane
#'
#' @param target A `tmux_pane`.
#'
#' @export
name.tmuxr_pane <- function(x) prop(x, "pane_title")


#' Get width of session
#'
#' @param target A session.
#'
#' @export
width.tmuxr_session <- function(x) as.numeric(prop(x, "window_width"))


#' Get height of session
#'
#' @param target A session.
#'
#' @export
height.tmuxr_session <- function(x) as.numeric(prop(x, "window_height"))


#' Get width of window
#'
#' @param target A window.
#'
#' @export
width.tmuxr_window <- function(x) as.numeric(prop(x, "window_width"))


#' Get height of window
#'
#' @param target A window.
#'
#' @export
height.tmuxr_window <- function(x) as.numeric(prop(x, "window_height"))


#' Get width of pane
#'
#' @param target A pane.
#'
#' @export
width.tmuxr_pane <- function(x) as.numeric(prop(x, "pane_width"))


#' Get height of pane
#'
#' @param target A pane.
#'
#' @export
height.tmuxr_pane <- function(x) as.numeric(prop(x, "pane_height"))



#' @export
`name<-.tmuxr_session` <- function(x, value) rename_session(x, new_name = value)
#' @export
`name<-.tmuxr_window` <- function(x, value) rename_window(x, new_name = value)


#' @export
`width<-.tmuxr_session` <- function(x, value) resize_window(x, width = value)
#' @export
`width<-.tmuxr_window` <- function(x, value) resize_window(x, width = value)
#' @export
`width<-.tmuxr_pane` <- function(x, value) resize_pane(x, width = value)

#' @export
`height<-.tmuxr_session` <- function(x, value) resize_window(x, height = value)
#' @export
`height<-.tmuxr_window` <- function(x, value) resize_window(x, height = value)
#' @export
`height<-.tmuxr_pane` <- function(x, value) resize_pane(x, height = value)
