context("session")

test_that("server is not already running", {
  kill_server()
  expect_false(is_running())
})

test_that("a new session can be created", {
  kill_server()
  expect_error(new_session(), NA)
})

test_that("a new session with a specific name can be created", {
  kill_server()
  s <- new_session("foo")
  expect_equal(name(s), "foo")
})

test_that("there are now two sessions", {
  kill_server()
  a <- new_session()
  b <- new_session()
  expect_length(list_sessions(), 2)
})

test_that("an existing session can be referenced", {
  kill_server()
  s <- new_session("foo")
  expect_equal(name(attach_session("foo")), "foo")
})

test_that("a session can be renamed", {
  kill_server()
  s <- new_session("foo")
  name(s) <- "bar"
  expect_equal(name(s), "bar")
})

kill_server()
