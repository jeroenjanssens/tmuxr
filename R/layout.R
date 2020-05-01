# layout ------------------------------------------------------------------


#' Change layout of a tmux window
#'
#' Functions to get and set the layout of a tmux window.
#'
#' @param target A tmuxr_window. If `NULL`, use currently active window.
#' @param value A string. Layout definition or name of preset.
#' @param width,height An integer. Width or height of the main pane.
#' @param reverse A logical. If `TRUE` the direction in which rotate the window
#'   is reversed. Default: `FALSE`.
#'
#' @return A string. Layout definition.
#'
#' @export
layout <- function(target = NULL) {
  prop(target, "window_layout")
}


#' @rdname layout
#' @export
`layout<-` <- function(target, value) {
  set_layout(target, value)
}


#' @rdname layout
#' @export
set_layout <- function(target = NULL, value) {
  flags <- c()
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))
  flags <- c(flags, value)
  tmux_command("select-layout", flags)
  invisible(target)
}


#' @rdname layout
#' @export
layout_even_horizontal <- function(target = NULL) {
  set_layout(target, "even-horizontal")
}


#' @rdname layout
#' @export
layout_even_vertical <- function(target = NULL) {
  set_layout(target, "even-vertical")
}


#' @rdname layout
#' @export
layout_main_horizontal <- function(target = NULL, height = NULL) {
  if (!is.null(height)) set_option(target, "main-pane-height", height)
  set_layout(target, "main-horizontal")
}


#' @rdname layout
#' @export
layout_main_vertical <- function(target = NULL, width = NULL) {
  if (!is.null(width)) set_option(target, "main-pane-width", width)
  set_layout(target, "main-vertical")
}


#' @rdname layout
#' @export
layout_tiled <- function(target = NULL) {
  set_layout(target, "tiled")
}


#' @rdname layout
#' @export
layout_next <- function(target = NULL) {
  set_layout(target, "-n")
}


#' @rdname layout
#' @export
layout_previous <- function(target = NULL) {
  set_layout(target, "-p")
}


#' @rdname layout
#' @export
layout_even <- function(target = NULL) {
  set_layout(target, "-E")
}


#' @rdname layout
#' @export
layout_undo <- function(target = NULL) {
  set_layout(target, "-o")
}


#' @rdname layout
#' @export
layout_rotate <- function(target = NULL, reverse = FALSE) {
  if (reverse) {
    flags <- "-U"
  } else {
    flags <- "-D"
  }
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))

  tmux_command("rotate-window", flags)
  invisible(target)
}


# style -------------------------------------------------------------------


#' Style of a tmux window or pane
#'
#' Functions to get and set the layout of a tmux window or pane.
#'
#' @param target A tmuxr_window or tmuxr_pane.
#' @param value A named list. Style definition.
#' @export
style <- function(target) {
  UseMethod("style")
}


#' @export
style.tmuxr_window <- function(target) {
  strpstyle(prop(target, "window-style"))
}


#' @export
style.tmuxr_pane <- function(target) {
  strpstyle(prop(target, "window-style"))
}


#' @rdname style
#' @export
`style<-` <- function(target, value) {
  UseMethod("style<-")
}


#' @export
`style<-.tmuxr_window` <- function(target, value) {
  set_option(target, "window-style", strfstyle(value), type = "window")
}


#' @export
`style<-.tmuxr_pane` <- function(target, value) {
  set_option(target, "window-style", strfstyle(value), type = "pane")
}


#' @rdname style
#' @export
set_style <- function(target, value) {
  style(target) <- value
}


#' Format and parse style strings
#'
#' Functions to convert a style string to a named list and back.
#'
#' @param ... Named strings and logicals or one named list.
#'   Colors and attributes.
#' @param x A string.
#'
#' @return A string or named list.
#'
#' @examples
#' strfstyle(fg = "red", bg = "#00ff00", blink = TRUE, align = FALSE)
#' strpstyle("fg=red,bg=#00ff00,blink,noalign")
#' @name style_convert
NULL


#' @rdname style_convert
#' @export
strfstyle <- function(...) {
  args <- list(...)
  styles <- c()

  if (length(args) == 1 && is.list(args[[1]]) && is.null(names(args))) {
    args <- args[[1]]
  }

  for (k in names(args)) {
    v <- args[[k]]

    if (is.logical(v)) {
      if (v) {
        styles <- c(styles, k)
      } else {
        styles <- c(styles, paste0("no", k))
      }
    } else {
      styles <- c(styles, paste0(k, "=", v))
    }
  }
  if (length(styles) > 0) {
    paste(styles, collapse = ",")
  } else {
    "default"
  }
}


#' @rdname style_convert
#' @export
strpstyle <- function(x) {
  style <- list()
  if (x %in% c("", "default")) return(list())
  parts <- unlist(strsplit(x, ",", fixed = TRUE))
  for (part in parts) {
    kv <- unlist(strsplit(part, "=", fixed = TRUE))
    if (length(kv) == 1) {
      if (substring(kv, 1, 2) == "no") {
        style[substring(kv, 3)] = FALSE
      } else {
        style[kv] = TRUE
      }
    } else {
      style[kv[1]] = kv[2]
    }
  }
  style
}



#' Swap two tmux windows or panes
#'
#' @param from A tmuxr_window or tmuxr_pane.
#' @param to A tmuxr_window or tmuxr_pane.
#' @param reverse A logical.
#' @param select A logical. If `FALSE`, do not select the new window or pane.
#'   Default: `TRUE`.
#'
#' @export
swap_pane <- function(from = NULL, to = NULL, reverse = FALSE, select = TRUE) {
  flags <- c()
  if (!select) flags <- c(flags, "-d")
  if (is.null(to)) {
    if (reverse) {
      flags <- c(flags, "-U")
    } else {
      flags <- c(flags, "-D")
    }
  } else {
    flags <- c(flags, "-s", get_target(to))
  }
  if (!is.null(from)) flags <- c(flags, "-t", get_target(from))

  tmux_command("swap-pane", flags)
  invisible(to)
}


#' @rdname swap_pane
#' @export
swap_window <- function(from = NULL, to = NULL, select = TRUE) {
  flags <- c()
  if (!select) flags <- c(flags, "-d")
  if (!is.null(to)) flags <- c(flags, "-s", get_target(to))
  if (!is.null(from)) flags <- c(flags, "-t", get_target(from))
  tmux_command("swap-window", flags)
  invisible(to)
}


# tmux_options(named list)
# tmux_options(): return named list of all options
