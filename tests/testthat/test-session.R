context("session")

if (!is_installed()) stop("tmux not found")
if (is_running()) stop("server is already running")

test_that("server is not already running", {
  expect_false(is_running())
})

test_that("a new session can be created", {
  expect_error(new_session(), NA)
})

test_that("a new session with a specific name can be created", {
  s <- new_session("foo")
  expect_equal(s$name, "foo")
})

test_that("there are now two sessions", {
  expect_length(list_sessions(), 2)
})

test_that("an existing session can be referenced", {
  expect_equal(attach_session("foo")$name, "foo")
})

test_that("a session can be renamed", {
  expect_equal(rename_session(attach_session("foo"), "bar")$name, "bar")
})

try(kill_server(), silent = TRUE)
