context("pipe")

if (!is_installed()) stop("tmux not found")
if (is_running()) stop("server is already running")

# test_that("pane can be piped", {
#   out_file <- tempfile("tmuxr") # , fileext = as.character(Sys.getpid())
#
#   s <- new_session(shell_command = "bash")
#   Sys.sleep(0.1)
#
#   s %>%
#     send_keys("PS1='$ '") %>%
#     pipe_pane(paste0("cat > ", out_file)) %>%
#     send_enter() %>%
#     send_keys("echo hi") %>%
#     send_enter()
#
#   output <- paste0(readLines(out_file, warn = FALSE), collapse = "\n")
#   unlink(out_file)
#
#   expect_equal(output, "\n$ echo hi\nhi\n$ ")
# })




try(kill_server(), silent = TRUE)
