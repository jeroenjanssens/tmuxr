#' @export
kill_server <- function() {
  tmux_kill_server()
}


#' @export
start_server <- function() {
  tmux_start_server()
}


#' @export
info <- function() {
  tmux_info()
}
