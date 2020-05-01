#' Execute a tmux command
#'
#' @param command A string.
#' @param ... Strings. Command flags.
#' @param .silent A Logical. Default: `FALSE`.
#'
#' @return A vector of strings.
#'
#' @examples
#' s <- new_session()
#' split_window(s)
#' tmux_command("list-panes", "-t" , "0")
#' kill_session(s)
#'
#' @export
tmux_command <- function(command, ..., .silent = FALSE) {
  stopifnot(is.character(command), length(command) == 1)

  tmux_options <- c()

  if (!is.null(getOption("tmux_config_file")))
    tmux_options <- c(tmux_options, "-f", getOption("tmux_config_file"))

  if (!is.null(getOption("tmux_socket_name")))
    tmux_options <- c(tmux_options, "-L", getOption("tmux_socket_name"))

  if (!is.null(getOption("tmux_socket_path")))
    tmux_options <- c(tmux_options, "-S", getOption("tmux_socket_path"))

  result <- processx::run(getOption("tmux_binary", "tmux"),
                          args = c(tmux_options, command, ...),
                          error_on_status = FALSE,
                          stderr_to_stdout = TRUE,
                          echo_cmd = getOption("tmux_echo", default = FALSE))

  if ((result$status > 0) && (!.silent)) {
    stop("tmux: ", result$stdout, call. = FALSE)
  }

  unlist(strsplit(result$stdout, "\n"))
}


#' Display a message
#'
#' Display a message.
#'
#' @param target A session, window, or pane.
#' @param message A string. The message to display. Refer to the FORMATS
#'   section of the tmux man page for the format.
#' @param verbose A logical. Print verbose logging as the format is parsed?
#'   Default: `FALSE`.
#' @param stdout A logical. If `TRUE`, the message is printed to standard
#'   output. If `FALSE`, the message is sent to `target`. Default: `TRUE`.
#'
#' @return A string if `stdout` is `TRUE`, otherwise `NULL`.
#'
#' @note
#' The `verbose` argument is not supported for tmux version < 2.9 and will be
#'   ignored. If `verbose` is `TRUE` a warning will be given.
#'
#' @examples
#' s <- new_session("jazz", height = 12)
#' display_message(s, "#{window_active}")
#' display_message(s, "session '#{session_name}' has height #{window_height}.")
#' kill_session(s)
#'
#' @export
display_message <- function(target = NULL,
                            message = NULL,
                            verbose = FALSE,
                            stdout = TRUE) {
  flags <- c()
  if (verbose) {
    if (tmux_version() < 2.9) {
      warning("The verbose argument is not supported for tmux version < 2.9 ",
              "and will be ignored.", call. = FALSE)
    } else {
      flags <- c(flags, "-v")
    }
  }
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
  } else if (is.null(x)) {
    NULL
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
#' @param target A tmuxr_session, tmuxr_window, or tmuxr_pane.
#' @param value A string. New name.
#' @return A string.
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
#' @param target A tmuxr_session, tmuxr_window, or tmuxr_pane.
#' @param value An integer.
#' @return An integer. The new width or height.
#' @note
#' The size of a tmuxr_pane can only be changed if there are other panes in the
#'   same window.
#'
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
name.tmuxr_session <-
  function(target) prop(target, "session_name")

#' @export
name.tmuxr_window <-
  function(target) prop(target, "window_name")

#' @export
name.tmuxr_pane <-
  function(target) prop(target, "pane_title")

#' @export
width.tmuxr_session <-
  function(target) as.numeric(prop(target, "window_width"))

#' @export
height.tmuxr_session <-
  function(target) as.numeric(prop(target, "window_height"))

#' @export
width.tmuxr_window <-
  function(target) as.numeric(prop(target, "window_width"))

#' @export
height.tmuxr_window <-
  function(target) as.numeric(prop(target, "window_height"))

#' @export
width.tmuxr_pane <-
  function(target) as.numeric(prop(target, "pane_width"))

#' @export
height.tmuxr_pane <-
  function(target) as.numeric(prop(target, "pane_height"))

#' @export
`name<-.tmuxr_session` <-
  function(target, value) rename_session(target, value)

#' @export
`name<-.tmuxr_window` <-
  function(target, value) rename_window(target, value)

#' @export
`name<-.tmuxr_pane` <- function(target, value) {
  flags <- c("-t", get_target(target),
             "-T", value)
  tmux_command("select-pane", flags)
  invisible(target)
}

#' @export
`width<-.tmuxr_session` <-
  function(target, value) resize_window(target, width = value)

#' @export
`width<-.tmuxr_window` <-
  function(target, value) resize_window(target, width = value)

#' @export
`width<-.tmuxr_pane` <-
  function(target, value) resize_pane(target, width = value)

#' @export
`height<-.tmuxr_session` <-
  function(target, value) resize_window(target, height = value)

#' @export
`height<-.tmuxr_window` <-
  function(target, value) resize_window(target, height = value)

#' @export
`height<-.tmuxr_pane` <-
  function(target, value) resize_pane(target, height = value)


#' Is tmux object active?
#'
#' @param target A tmuxr_window or tmuxr_pane.
#' @return A logical.
#' @export
is_active <- function(target) UseMethod("is_active")

#' @export
is_active.tmuxr_window <-
  function(target) prop(target, "window_active") == "1"

#' @export
is_active.tmuxr_pane <-
  function(target) prop(target, "pane_active") == "1"


#' Index of a tmux object
#'
#' @param target A tmuxr_window or tmuxr_pane.
#' @return An integer.
#' @export
index <- function(target) UseMethod("index")

#' @export
index.tmuxr_window <-
  function(target) as.numeric(prop(target, "window_index"))

#' @export
index.tmuxr_pane <-
  function(target) as.numeric(prop(target, "pane_index"))


#' @export
option_set <- function(target = NULL, option, value = NULL,
                       type = c("session", "window", "pane", "server"),
                       append = FALSE,
                       expand = FALSE,
                       global = FALSE,
                       unset = FALSE,
                       override = TRUE) {

  flags <- switch(match.arg(type),
                  session = NULL,
                  window = "-w",
                  pane = "-p",
                  server = "-s")

  if (append) flags <- c(flags, "-a")
  if (expand) flags <- c(flags, "-F")
  if (unset) flags <- c(flags, "-u")
  if (!override) flags <- c(flags, "-o")
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))
  flags <- c(flags, option, value)
  tmux_command("set-option", flags)
  invisible(target)
}

