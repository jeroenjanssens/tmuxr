if (is_installed()) {
  new_session()
  Sys.sleep(0.1)
  socket_path <- getOption("tmux_socket_path")
  kill_server()
  Sys.sleep(0.1)
  fs::file_delete(socket_path)
  Sys.sleep(0.1)
  if (fs::file_exists(socket_path)) {
    message("Socket ", socket_path, " could not be deleted")
  } else {
    message("Socket ", socket_path, " successfully deleted")
  }
}
