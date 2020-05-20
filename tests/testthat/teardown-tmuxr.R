if (is_installed()) {
  new_session()
  Sys.sleep(0.1)
  socket_dir <- dirname(prop(NULL, "socket_path"))
  kill_server()
  Sys.sleep(0.1)
  unlink(socket_dir, recursive = TRUE, force = TRUE)
  Sys.sleep(0.1)
  if (file.exists(socket_dir)) {
    message("Socket directory ", socket_dir, " could not be deleted")
  } else {
    message("Socket directory ", socket_dir, " successfully deleted")
  }
}
