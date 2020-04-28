#' Select a tmux window
#'
#' @param target A tmuxr_session or tmuxr_window. If `NULL`, the
#'   last session is used. Default: `NULL`.
#' @param token A string. Default `NULL`.
#'
#' @return A tmuxr_window.
#' @export
select_window <- function(target = NULL, token = NULL) {
  if (inherits(target, "tmuxr_window")) {
    if (!is.null(token)) {
      warning("token is ignored when target is a tmuxr_window", call. = FALSE)
    }
    tmux_command("select-window", "-t", get_target(target))
    target
  } else  {
    tmux_command("select-window", "-t", paste0(get_target(target), ":", token))
    attach_window(prop(get_target(target), "window_id"), lookup_id = FALSE)
  }
}

#' @rdname select_window
#' @export
select_window_active <- function(target = NULL) select_window(target)

#' @rdname select_window
#' @export
select_window_last <- function(target = NULL) select_window(target, "{last}")

#' @rdname select_window
#' @export
select_window_next <- function(target = NULL) select_window(target, "{next}")

#' @rdname select_window
#' @export
select_window_previous <- function(target = NULL) select_window(target, "{previous}")

#' @rdname select_window
#' @export
select_window_start <- function(target = NULL) select_window(target, "{start}")

#' @rdname select_window
#' @export
select_window_end <- function(target = NULL) select_window(target, "{end}")


#' Select a tmux pane
#'
#' Note that selecting a pane from a non-active window does not select that
#'   window.
#'
#' @param target A tmuxr_session, tmuxr_window, or tmuxr_pane. If `NULL`, the
#'   currently active pane is used. Default: `NULL`.
#' @param token A string. Default `NULL`.
#'
#' @return A tmuxr_pane.
#' @export
select_pane <- function(target = NULL, token = NULL) {
  if (inherits(target, "tmuxr_pane")) {
    if (!is.null(token)) {
      warning("token is ignored when target is a tmuxr_pane", call. = FALSE)
    }
    tmux_command("select-pane", "-t", get_target(target))
    target
  } else  {
    tmux_command("select-pane", "-t", paste0(get_target(target), ".", token))
    attach_pane(prop(get_target(target), "pane_id"), lookup_id = FALSE)
  }
}

#' @rdname select_pane
#' @export
select_pane_active <- function(target = NULL) select_pane(target)

#' @rdname select_pane
#' @export
select_pane_last <- function(target = NULL) select_pane(target, "{last}")

#' @rdname select_pane
#' @export
select_pane_next <- function(target = NULL) select_pane(target, "{next}")

#' @rdname select_pane
#' @export
select_pane_previous <- function(target = NULL) select_pane(target, "{previous}")

#' @rdname select_pane
#' @export
select_pane_top <- function(target = NULL) select_pane(target, "{top}")

#' @rdname select_pane
#' @export
select_pane_bottom <- function(target = NULL) select_pane(target, "{bottom}")

#' @rdname select_pane
#' @export
select_pane_left <- function(target = NULL) select_pane(target, "{left}")

#' @rdname select_pane
#' @export
select_pane_right <- function(target = NULL) select_pane(target, "{right}")

#' @rdname select_pane
#' @export
select_pane_top_left <- function(target = NULL) select_pane(target, "{top-left}")

#' @rdname select_pane
#' @export
select_pane_top_right <- function(target = NULL) select_pane(target, "{top-right}")

#' @rdname select_pane
#' @export
select_pane_bottom_left <- function(target = NULL) select_pane(target, "{bottom-left}")

#' @rdname select_pane
#' @export
select_pane_bottom_right <- function(target = NULL) select_pane(target, "{bottom-right}")

#' @rdname select_pane
#' @export
select_pane_up_of <- function(target = NULL) select_pane(target, "{up-of}")

#' @rdname select_pane
#' @export
select_pane_down_of <- function(target = NULL) select_pane(target, "{down-of}")

#' @rdname select_pane
#' @export
select_pane_left_of <- function(target = NULL) select_pane(target, "{left-of}")

#' @rdname select_pane
#' @export
select_pane_right_of <- function(target = NULL) select_pane(target, "{right-of}")
