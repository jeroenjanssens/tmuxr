context("server")

test_that("the server is installed", {
  skip_if_tmux_not_installed()
  expect_true(is_installed())
})

test_that("the server can be started", {
  skip_if_tmux_not_installed()
  expect_null(start_server())
})

test_that("the server can be killed", {
  skip_if_tmux_not_installed()
  expect_null(kill_server())
})

test_that("the server is not running", {
  skip_if_tmux_not_installed()
  expect_false(is_running())
})

test_that("the server is running", {
  skip_if_tmux_not_installed()
  s <- new_session()
  expect_true(is_running())
  kill_session(s)
})

test_that("the version is returned as numeric", {
  skip_if_tmux_not_installed()
  expect_true(is.numeric(tmux_version()))
})

test_that("the version is returned as character", {
  skip_if_tmux_not_installed()
  expect_true(is.character(tmux_version(as_numeric = FALSE)))
})
