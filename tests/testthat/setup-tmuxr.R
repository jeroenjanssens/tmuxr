if (Sys.getenv("TMUX_BINARY") != "") {
  options(tmux_binary = Sys.getenv("TMUX_BINARY"))
}

message("Using binary: ", getOption("tmux_binary", "tmux"))

options(tmux_config_file = "/dev/null",
        tmux_socket_name = paste0("test-",
                                  basename(getOption("tmux_binary", "tmux"))))

if (!is_installed()) stop("tmux not found")

message("Version: ", tmux_version(as_numeric = FALSE))

if (is_running()) stop("server is already running")
