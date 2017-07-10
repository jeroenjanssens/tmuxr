#' @importFrom magrittr %>%
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
    invisible(result)
  }
}

tmux_kill_server <- tmux_command("kill-server")
tmux_kill_session <- tmux_command("kill-session")
tmux_list_panes <- tmux_command("list-panes")
tmux_list_sessions <- tmux_command("list-sessions")
tmux_list_windows <- tmux_command("list-windows")
tmux_new_session <- tmux_command("new-session")
tmux_rename_session <- tmux_command("rename-session")
tmux_send_keys <- tmux_command("send-keys")
tmux_start_server <- tmux_command("start-server")
tmux_info <- tmux_command("info")


