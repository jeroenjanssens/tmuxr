#' @importFrom magrittr %>%
#' @importFrom utils head tail
#' @export
magrittr::`%>%`


#' @keywords internal
tmux_command <- function(command) {
  function(...) {
    suppressWarnings(
      result <- system2("tmux", c(command, ...), stdout = TRUE, stderr = TRUE)
    )
    status <- attr(result, "status")
    if (!is.null(status) && (status > 0)) {
      stop(stringr::str_c("tmux: ", result, collapse = " "))
    }
    result
  }
}

#' @keywords internal
tmux_capture_pane <- tmux_command("capture-pane")

#' @keywords internal
tmux_kill_server <- tmux_command("kill-server")

#' @keywords internal
tmux_kill_session <- tmux_command("kill-session")

#' @keywords internal
tmux_list_panes <- tmux_command("list-panes")

#' @keywords internal
tmux_list_sessions <- tmux_command("list-sessions")

#' @keywords internal
tmux_list_windows <- tmux_command("list-windows")

#' @keywords internal
tmux_new_session <- tmux_command("new-session")

#' @keywords internal
tmux_pipe_pane <- tmux_command("pipe-pane")

#' @keywords internal
tmux_rename_session <- tmux_command("rename-session")

#' @keywords internal
tmux_send_keys <- tmux_command("send-keys")

#' @keywords internal
tmux_start_server <- tmux_command("start-server")
