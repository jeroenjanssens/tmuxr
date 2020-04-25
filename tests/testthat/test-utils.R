context("utils")

test_that("display_message works", {
  s <- new_session()

  # Q: When was verbose introduced?
  # expect_identical(display_message(s, "foo", verbose = TRUE),
  #                  c("# expanding format: foo",
  #                    "# result is: foo",
  #                    "foo"))

  expect_null(display_message(s, "bar", stdout = FALSE))
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

  # Doesn't work on older version
  # old_name <- name(p)
  # name(p) <- "bar"
  # expect_false(old_name == name(p))

  kill_session(s)
})

test_that("the width and height of a session can be changed", {
  skip_if(tmux_version() < 2.9)
  o <- new_session("foo")
  v <- width(o)
  width(o) <- width(o) + 1
  expect_false(v == width(o))

  v <- height(o)
  height(o) <- height(o) + 1
  expect_false(v == height(o))
})

test_that("the width and height of a window can be changed", {
  skip_if(tmux_version() < 2.9)
  o <- list_windows()[[1]]
  v <- width(o)
  width(o) <- width(o) + 1
  expect_false(v == width(o))

  v <- height(o)
  height(o) <- height(o) + 1
  expect_false(v == height(o))
})

test_that("the width and height of a pane can be changed", {
  skip_on_travis()
  split_window(vertical = TRUE)
  split_window(vertical = FALSE)

  o <- list_panes()[[3]] # select last pane
  v <- width(o)
  width(o) <- width(o) + 1
  expect_false(v == width(o))

  v <- height(o)
  height(o) <- height(o) + 1
  expect_false(v == height(o))

  kill_server()
})

test_that("index works", {
  skip_on_travis()
  s <- new_session()
  w1 <- select_window(s)
  expect_identical(index(w1), 0)
  w2 <- new_window()
  expect_identical(index(w1), 0)
  expect_identical(index(w2), 1)
  p2 <- split_window(w1)
  expect_identical(index(p2), 1)
})


