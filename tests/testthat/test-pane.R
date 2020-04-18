context("pane")

test_that("contents can be captured", {

  specified_height <- 10
  s <- new_session(shell_command = "cat", height = specified_height)

  # Prior to version 2.6, the actual height was one less than the specified height.
  # See https://github.com/tmux/tmux/blob/349617a818ec8ed0f1cdedac64f5d9126d920f87/CHANGES#L634-L636

  if (tmux_version(as_numeric = TRUE) >= 2.6) {
    expected_height <- specified_height
  } else {
    expected_height <- specified_height - 1
  }

  expect_length(capture_pane(s), expected_height)
  expect_match(paste0(rep("\n", expected_height), collapse = ""),
               capture_pane(s, cat = TRUE), fixed = TRUE)

  expect_length(capture_pane(s, start = 0, end = 1), 2)

  kill_session(s)
})

kill_server()
