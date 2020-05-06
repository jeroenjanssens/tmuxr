if (Sys.getenv("TMUX_BINARY") != "") {
  options(tmux_binary = Sys.getenv("TMUX_BINARY"))
}

options(tmux_config_file = "/dev/null",
        tmux_socket_name = paste0("test-",
                                  basename(getOption("tmux_binary", "tmux"))))

if (!is_installed()) {
  message("Binary not found, skipping tests.")
} else {
  message("Binary found: '", getOption("tmux_binary", "tmux"),
          "' with version: ", tmux_version(as_numeric = FALSE), ".")
}

skip_if_tmux_not_installed <- function() {
  skip_if_not(is_installed())
}
