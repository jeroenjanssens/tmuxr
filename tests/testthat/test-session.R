context("session")

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
  expect_equal(session_from_name("foo")$name, "foo")
})

test_that("a session can be renamed", {
  expect_equal(rename_session(session_from_name("foo"), "bar")$name, "bar")
})
