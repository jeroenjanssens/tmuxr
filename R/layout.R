#' @export
layout <- function(target) UseMethod("layout")

#' @export
`layout<-` <- function(target, value) UseMethod("layout<-")

#' @export
layout.tmuxr_window <- function(target = NULL) {
  prop(target, "window_layout")
}

#' @export
`layout<-.tmuxr_window` <- function(target = NULL, value) layout_select(target, value)

#' @export
layout.tmuxr_pane <- function(target = NULL) {
  prop(target, "window_layout")
}

#' @export
`layout<-.tmuxr_pane` <- function(target = NULL, value) layout_select(target, value)

#' @keywords internal
layout_select <- function(target = NULL, value) {
  flags <- c()
  if (!is.null(target)) flags <- c(flags, "-t", get_target(target))
  flags <- c(flags, value)
  tmux_command("select-layout", flags)
  invisible(target)
}


#' @export
layout_even_horizontal <-
  function(target = NULL) layout_select(target, "even-horizontal")

#' @export
layout_even_vertical <-
  function(target = NULL) layout_select(target, "even-vertical")

#' @export
layout_main_horizontal <- function(target = NULL, height = NULL) {
  if (!is.null(height)) option_set(target, "main-pane-height", height)
  layout_select(target, "main-horizontal")
}

#' @export
layout_main_vertical <- function(target = NULL, width = NULL) {
  if (!is.null(width)) option_set(target, "main-pane-width", width)
  layout_select(target, "main-vertical")
}

#' @export
layout_tiled <-
  function(target = NULL) layout_select(target, "tiled")

#' @export
layout_next <-
  function(target = NULL) layout_select(target, "-n")

#' @export
layout_previous <-
  function(target = NULL) layout_select(target, "-p")

#' @export
layout_even <-
  function(target = NULL) layout_select(target, "-E")

#' @export
layout_undo <-
  function(target = NULL) layout_select(target, "-o")

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

#' @export
style_pane <- function(target = NULL, background = NULL, foreground = NULL, ...) {
  styles <- c(...)
  if (!is.null(background)) styles <- c(styles, paste0("bg=", background))
  if (!is.null(foreground)) styles <- c(styles, paste0("fg=", foreground))
  option_set(target, "window-style",
             value = paste(styles, collapse = ","),
             type = "pane")
}

#' @export
style_window <- function(target = NULL, background = NULL, foreground = NULL, ...) {
  styles <- c(...)
  if (!is.null(background)) styles <- c(styles, paste0("bg=", background))
  if (!is.null(foreground)) styles <- c(styles, paste0("fg=", foreground))
  option_set(target, "window-style",
             value = paste(styles, collapse = ","),
             type = "window")
}


#' @export
style <- function(target) UseMethod("style")

#' @export
`style<-` <- function(target, value) UseMethod("style<-")

#' Get style of tmux window
#'
#' @export
style.tmuxr_window <- function(target) {
  parse_style(prop(target, "window-style"))
}

#' Get style of tmux pane
#'
#' @export
style.tmuxr_pane <- function(target) {
  parse_style(prop(target, "window-style"))
}

#' @export
`style<-.tmuxr_window` <- function(target, value) {
  option_set(target, "window-style", format_style(value), type = "window")
}

#' @export
`style<-.tmuxr_pane` <- function(target, value) {
  option_set(target, "window-style", format_style(value), type = "pane")
}

#' @export
format_style <- function(...) {
  args <- list(...)

  if (length(args) == 1 && is.list(args[[1]]) && is.null(names(args))) {
    args <- args[[1]]
  }

  styles <- c()

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
  paste(styles, collapse = ",")
}

#' @export
parse_style <- function(x) {
  style <- list()
  if (x == "default") return(NULL)
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

# options
# prop
# style
# layout
