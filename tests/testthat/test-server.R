context("server")

test_that("the server is installed", {
  expect_true(is_installed())
})

test_that("the server can be started", {
  expect_null(start_server())
})

test_that("the server can be killed", {
  expect_null(kill_server())
})

test_that("the server is not running", {
  expect_false(is_running())
})

test_that("the server is running", {
  s <- new_session()
  expect_true(is_running())
  kill_session(s)
})

test_that("the version is returned as numeric", {
  expect_true(is.numeric(tmux_version()))
})

test_that("the version is returned as character", {
  expect_true(is.character(tmux_version(as_numeric = FALSE)))
})
