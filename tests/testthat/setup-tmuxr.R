options(tmux_config_file = "/dev/null",
        tmux_socket_name = "test")

if (!is_installed()) stop("tmux not found")
if (is_running()) stop("server is already running")
