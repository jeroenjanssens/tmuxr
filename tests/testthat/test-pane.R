context("pane")

test_that("contents can be captured", {
  s <- new_session(shell_command = "bash -c 'PS1=\"$ \" bash'", height = 10)
  expect_length(capture_pane(s), 10)
  expect_match("$\n\n\n\n\n\n\n\n\n", capture_pane(s, cat = TRUE), fixed = TRUE)
})

kill_server()
