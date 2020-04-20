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

test_that("the window name can be set when creating a new session", {
  kill_server()
  s <- new_session(window_name = "baz")
  expect_identical(name(list_windows(s)[[1]]), "baz")
})

test_that("the start directory can be set when creating a new session", {
  kill_server()
  start_dir <- "/"
  s <- new_session(start_directory = start_dir, shell_command = "pwd; cat")
  Sys.sleep(0.1)
  expect_identical(capture_pane(s, start = 0, end = 0), start_dir)
  kill_session(s)
})


test_that("sessions are printed correctly", {
  kill_server()
  s <- new_session("foobarbaz")
  expect_output(print(s), "^tmuxr session foobarbaz: 1 windows ")
})


kill_server()
