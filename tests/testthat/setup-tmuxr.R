# options(tmux_config_file = "/dev/null",
#         tmux_socket_name = "test",
#         tmux_socket_path = tempfile("tmuxr-socket-"))

if (!is_installed()) stop("tmux not found")
if (is_running()) stop("server is already running")
