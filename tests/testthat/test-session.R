context("session")

test_that("server is not already running", {
  skip_if_tmux_not_installed()
  expect_false(is_running())
})

test_that("a new session can be created", {
  skip_if_tmux_not_installed()
  expect_error(new_session(), NA)
})

test_that("a new session with a specific name can be created", {
  skip_if_tmux_not_installed()
  s <- new_session("foo")
  expect_equal(name(s), "foo")
  kill_session(s)
})

test_that("an existing session can be referenced", {
  skip_if_tmux_not_installed()
  s <- new_session("foo")
  expect_equal(name(attach_session("foo")), "foo")
  kill_session(s)
})

test_that("a session can be renamed", {
  skip_if_tmux_not_installed()
  s <- new_session("foo")
  rename_session(s, "bar")
  expect_equal(name(s), "bar")
  kill_session(s)
})

test_that("the window name can be set when creating a new session", {
  skip_if_tmux_not_installed()
  s <- new_session(window_name = "baz")
  expect_identical(name(list_windows(s)[[1]]), "baz")
  kill_session(s)
})

test_that("the start directory can be set when creating a new session", {
  skip_if_tmux_not_installed()
  start_dir <- "/"
  s <- new_session(start_directory = start_dir, shell_command = "pwd; cat")
  Sys.sleep(0.5)
  expect_identical(capture_pane(s, start = 0, end = 0), start_dir)
  kill_session(s)
})


test_that("sessions are printed correctly", {
  skip_if_tmux_not_installed()
  s <- new_session("foobarbaz")
  expect_output(print(s), "^tmuxr session foobarbaz: 1 windows ")
  kill_session(s)
})

test_that("all other sessions can be killed", {
  skip_if_tmux_not_installed()
  s1 <- new_session()
  s2 <- new_session()

  kill_session(s1, inverse = TRUE)
  expect_identical(list_sessions()[[1]], s1)
  kill_session(s1)
})
