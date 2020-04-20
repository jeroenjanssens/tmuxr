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


#' Name of a tmux object
#'
#' @param target A `tmuxr_session`, `tmuxr_window`, or `tmuxr_pane`.
#' @param value String.
#' @seealso [rename_session()], [rename_window()]
#' @name object_name
NULL


#' @rdname object_name
#' @export
name <- function(target) UseMethod("name")


#' @rdname object_name
#' @export
`name<-` <- function(target, value) UseMethod("name<-")


#' Width and height of a tmux object
#'
#' @param target A `tmuxr_session`, `tmuxr_window`, or `tmuxr_pane`.
#' @param value Numeric.
#' @seealso [resize_window()], [resize_pane()]
#' @name object_size
NULL


#' @rdname object_size
#' @export
width <- function(target) UseMethod("width")


#' @rdname object_size
#' @export
`width<-` <- function(target, value) UseMethod("width<-")


#' @rdname object_size
#' @export
height <- function(target) UseMethod("height")


#' @rdname object_size
#' @export
`height<-` <- function(target, value) UseMethod("height<-")


#' @export
name.tmuxr_session <- function(target) prop(target, "session_name")

#' @export
name.tmuxr_window <- function(target) prop(target, "window_name")

#' @export
name.tmuxr_pane <- function(target) prop(target, "pane_title")

#' @export
width.tmuxr_session <- function(target) as.numeric(prop(target, "window_width"))

#' @export
height.tmuxr_session <- function(target) as.numeric(prop(target, "window_height"))

#' @export
width.tmuxr_window <- function(target) as.numeric(prop(target, "window_width"))

#' @export
height.tmuxr_window <- function(target) as.numeric(prop(target, "window_height"))

#' @export
width.tmuxr_pane <- function(target) as.numeric(prop(target, "pane_width"))

#' @export
height.tmuxr_pane <- function(target) as.numeric(prop(target, "pane_height"))

#' @export
`name<-.tmuxr_session` <- function(target, value) rename_session(target, value)

#' @export
`name<-.tmuxr_window` <- function(target, value) rename_window(target, value)

#' @export
`width<-.tmuxr_session` <- function(target, value) resize_window(target, value)

#' @export
`width<-.tmuxr_window` <- function(target, value) resize_window(target, value)

#' @export
`width<-.tmuxr_pane` <- function(target, value) resize_pane(target, value)

#' @export
`height<-.tmuxr_session` <- function(target, value) resize_window(target, value)

#' @export
`height<-.tmuxr_window` <- function(target, value) resize_window(target, value)

#' @export
`height<-.tmuxr_pane` <- function(target, value) resize_pane(target, value)
