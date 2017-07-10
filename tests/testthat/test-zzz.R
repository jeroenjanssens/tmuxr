context("server")

if (is_running()) stop("server is already running")

test_that("the server can be killed", {
  new_session()
  expect_error(kill_server(), NA)
  expect_error(kill_server())
})

try(kill_server(), silent = TRUE)
