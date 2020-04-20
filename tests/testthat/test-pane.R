context("pane")

test_that("contents can be captured", {

  specified_height <- 10
  s <- new_session(shell_command = "cat", height = specified_height)

  # Before version 2.6, the actual height is one less than the specified height
  # see https://github.com/tmux/tmux/blob/349617a818/CHANGES#L634-L636

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

test_that("stdout of pane can be piped", {
  out_file <- tempfile("tmuxr")
  s <- new_session(shell_command = "cat > /dev/null")
  pipe_pane(s, paste0("cat >> ", out_file), stdout = TRUE)
  send_keys(s, "Hello there!", literal = TRUE)
  send_keys(s, "Enter")
  pipe_pane(s)
  kill_session(s)
  Sys.sleep(0.1)
  output <- paste0(readLines(out_file, warn = FALSE), collapse = "\n")
  unlink(out_file)
  expect_identical(output, "Hello there!")
})

test_that("stdin of pane can be piped", {
  skip_if_not(tmux_version(as_numeric = TRUE) >= 2.8)
  s <- new_session(shell_command = "cat > /dev/null")
  pipe_pane(s, "seq 5", stdin = TRUE)
  pipe_pane(s)
  Sys.sleep(0.1)
  expect_identical(head(capture_pane(s), 5),
                   as.character(seq(5)))
  kill_session(s)
})

test_that("panes are printed correctly", {
  kill_server()
  s <- new_session("foobarbaz", shell_command = "cat")
  p <- list_panes(s)[[1]]
  expect_output(print(p), "^tmuxr pane foobarbaz:0.0: ")
})



kill_server()
