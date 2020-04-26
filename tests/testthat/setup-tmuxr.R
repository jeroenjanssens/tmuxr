options(tmux_config_file = "/dev/null",
        tmux_socket_name = "test")

if (Sys.getenv("TMUX_BINARY") != "") {
  options(tmux_binary = Sys.getenv("TMUX_BINARY"))
}

message("Using binary ", getOption("tmux_binary", "tmux"))
if (!is_installed()) stop("tmux not found")
if (is_running()) stop("server is already running")
