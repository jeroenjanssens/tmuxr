# Sys.setenv(TMUX_TMPDIR = tempdir())

if (Sys.getenv("TMUX_BINARY") != "") {
  options(tmux_binary = Sys.getenv("TMUX_BINARY"))
}

options(tmux_config_file = "/dev/null",
        tmux_socket_path = fs::file_temp(tmp_dir = fs::path_wd()))

if (!is_installed()) {
  message("Binary not found, skipping tests.")
} else {
  message("Binary found: '", getOption("tmux_binary", "tmux"),
          "' with version: ", tmux_version(as_numeric = FALSE), ".")
}

skip_if_tmux_not_installed <- function() {
  skip_if_not(is_installed())
}
