context("server")

if (!is_installed()) stop("tmux not found")
if (is_running()) stop("server is already running")

test_that("the server can be killed", {
  new_session()  # This is the only way to start the server
  expect_error(kill_server(), NA)
  expect_error(kill_server())
})

try(kill_server(), silent = TRUE)
