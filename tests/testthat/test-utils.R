context("utils")

test_that("display_message works", {
  s <- new_session()

  expect_identical(display_message(s, "foo"), "foo")

  if (tmux_version() < 2.9) {
    expect_warning(display_message(s, "foo", verbose = TRUE))
  } else {
    expect_identical(display_message(s, "foo", verbose = TRUE),
                     c("# expanding format: foo",
                       "# result is: foo",
                       "foo"))
  }

  if (tmux_version() >= 2.3) {
    expect_null(display_message(s, "bar", stdout = FALSE))
  }
  kill_session(s)
})

test_that("the name of an object can be changed", {
  s <- new_session("foo")
  w <- list_windows()[[1]]
  p <- list_panes()[[1]]

  old_name <- name(s)
  name(s) <- "bar"
  expect_false(old_name == name(s))

  old_name <- name(w)
  name(w) <- "bar"
  expect_false(old_name == name(w))

  kill_session(s)
})

test_that("the width and height of a session can be changed", {
  s <- new_session()

  v <- width(s)

  if (tmux_version() < 2.9) {
    expect_error(width(s) <- width(s) + 1)
  } else {
    width(s) <- width(s) + 1
    expect_false(v == width(s))
  }

  v <- height(s)

  if (tmux_version() < 2.9) {
    expect_error(height(s) <- height(s) + 1)
  } else {
    height(s) <- height(s) + 1
    expect_false(v == height(s))
  }

  kill_session(s)
})

test_that("the width and height of a window can be changed", {
  s <- new_session()
  w <- list_windows()[[1]]

  v <- width(w)

  if (tmux_version() < 2.9) {
    expect_error(width(w) <- width(w) + 1)
  } else {
    width(w) <- width(w) + 1
    expect_false(v == width(w))
  }

  v <- height(w)

  if (tmux_version() < 2.9) {
    expect_error(height(w) <- height(w) + 1)
  } else {
    height(w) <- height(w) + 1
    expect_false(v == height(w))
  }

  kill_session(s)
})

test_that("the width and height of a pane can be changed", {
  s <- new_session()
  split_window(vertical = TRUE)
  split_window(vertical = FALSE)

  o <- list_panes()[[3]] # select last pane
  v <- width(o)
  width(o) <- width(o) + 1
  expect_false(v == width(o))

  v <- height(o)
  height(o) <- height(o) + 1
  expect_false(v == height(o))

  kill_session(s)
})

test_that("index works", {
  s <- new_session()
  w1 <- select_window(s)
  expect_identical(index(w1), 0)
  w2 <- new_window()
  expect_identical(index(w1), 0)
  expect_identical(index(w2), 1)
  p2 <- split_window(w1)
  expect_identical(index(p2), 1)
  kill_session(s)
})


