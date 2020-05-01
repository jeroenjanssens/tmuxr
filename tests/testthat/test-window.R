context("window")

test_that("an existing window can be referenced", {
  s <- new_session(window_name = "foo")
  expect_identical(attach_window("foo"), list_windows(s)[[1]])
  kill_session(s)
})

test_that("windows are printed correctly", {
  s <- new_session("foobarbaz", shell_command = "cat")
  w <- list_windows(s)[[1]]
  expect_output(print(w), "^tmuxr window foobarbaz:0: ")
  kill_session(s)
})

test_that("window can be created", {
  s <- new_session()
  expect_length(list_windows(s), 1)
  new_window()
  expect_length(list_windows(s), 2)
  w <- new_window(s, "baz")
  expect_length(list_windows(s), 3)
  expect_identical(name(w), "baz")
  kill_session(s)

  s1 <- new_session("foo", "a")
  s2 <- new_session("bar", "x")
  new_window(s1, "b")
  new_window(s2, "y")

  expect_identical(sapply(list_windows(s1), name), c("a", "b"))
  expect_identical(sapply(list_windows(s2), name), c("x", "y"))
  kill_session(s1)
  kill_session(s2)
})

test_that("windows can be killed", {
  s <- new_session()
  w1 <- list_windows(s)[[1]]
  w2 <- new_window()

  kill_window(w1)
  expect_identical(list_windows(s)[[1]], w2)

  kill_session(s)
})

test_that("other windows can be killed", {
  s <- new_session()
  w1 <- list_windows(s)[[1]]
  new_window()
  new_window()
  new_window()

  kill_window(w1, inverse = TRUE)

  expect_length(list_windows(s), 1)
  expect_identical(list_windows(s)[[1]], w1)

  kill_session(s)
})

test_that("window focus works", {
  s <- new_session()
  w1 <- list_windows(s)[[1]]
  expect_true(is_active(w1))
  w2 <- new_window()
  expect_false(is_active(w1))
  expect_true(is_active(w2))
  w3 <- new_window(focus = FALSE)
  expect_false(is_active(w1))
  expect_true(is_active(w2))
  expect_false(is_active(w3))
  kill_session(s)
})

test_that("the start directory can be set when creating a new window", {
  start_dir <- "/"
  s <- new_session()
  w <- new_window(start_directory = start_dir, shell_command = "pwd; cat")
  Sys.sleep(0.1)
  expect_identical(capture_pane(w, start = 0, end = 0), start_dir)
  kill_session(s)
})


test_that("windows can be split", {
  s <- new_session()
  p1 <- list_panes(s)[[1]]
  expect_true(is_active(p1))
  p2 <- split_window(s, size = 5)
  expect_length(list_panes(s), 2)
  if (tmux_version() >= 2.6) {
    expect_identical(tmuxr:::prop(p1, "pane_at_top"), "1")
    expect_identical(tmuxr:::prop(p2, "pane_at_bottom"), "1")
  }
  expect_identical(height(p2), 5)
  kill_session(s)

  s <- new_session()
  p1 <- list_panes(s)[[1]]
  p2 <- split_window(s, vertical = FALSE, size = 10)
  expect_identical(height(p1), height(p2))
  expect_identical(width(p1), 69)
  expect_identical(width(p2), 10)
  kill_session(s)

  s <- new_session()
  p1 <- list_panes(s)[[1]]
  p2 <- split_window(s, before = TRUE)
  if (tmux_version() >= 2.6) {
    expect_identical(tmuxr:::prop(p1, "pane_at_bottom"), "1")
    expect_identical(tmuxr:::prop(p2, "pane_at_top"), "1")
  }
  kill_session(s)

  s <- new_session(width = 80)
  p1 <- list_panes(s)[[1]]
  p2 <- split_window(s, size = 0.25, vertical = FALSE)
  expect_identical(width(p1), 59)
  expect_identical(width(p2), 20)
  kill_session(s)
})

test_that("windows can be split with full", {
  skip_if(tmux_version() < 2.3)

  s <- new_session()
  p1 <- list_panes(s)[[1]]
  p2 <- split_window(s)
  p3 <- split_window(p2, vertical = FALSE, full = TRUE)
  expect_identical(height(p3), height(s))
  kill_session(s)

  s <- new_session()
  p1 <- list_panes(s)[[1]]
  p2 <- split_window(s, vertical = FALSE)
  p3 <- split_window(p2, full = TRUE)
  expect_identical(width(p3), width(s))
  kill_session(s)
})

test_that("the start directory can be set when splitting a window", {
  start_dir <- "/"
  s <- new_session(shell_command = "pwd; cat")
  p1 <- list_panes(s)[[1]]
  p2 <- split_window(start_directory = start_dir, shell_command = "pwd; cat")
  Sys.sleep(0.1)
  expect_identical(capture_pane(p2, start = 0, end = 0), start_dir)
  expect_false(capture_pane(p1, start = 0, end = 0) ==
                 capture_pane(p2, start = 0, end = 0))
  kill_session(s)
})
