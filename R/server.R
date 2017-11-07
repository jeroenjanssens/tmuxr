#' Kill the tmux server.
#'
#' @export
kill_server <- function() {
  tmux_kill_server()
}


#' Start the tmux server.
#'
#' @export
start_server <- function() {
  tmux_start_server()
}

#' Is the tmux server running?
#'
#' @export
is_running <- function() {
  if (.Platform$OS.type == "windows") {
    grepl("tmux", system2("tasklist", c("/FI \"IMAGENAME eq tmux.exe\" /FO CSV /NH"), stdout = TRUE))
  } else {
    pids <- suppressWarnings(system2("pgrep", c("-x", "tmux"),
                                     stdout = TRUE, stderr = FALSE))
    length(pids) > 0
  }
}
