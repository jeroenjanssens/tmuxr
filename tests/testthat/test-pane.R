context("pane")

test_that("an existing pane can be referenced", {
  skip_if_tmux_not_installed()
  s <- new_session()
  expect_identical(attach_pane(0), list_panes(s)[[1]])
  kill_session(s)
})

test_that("pane can be killed", {
  skip_if_tmux_not_installed()
  s <- new_session()
  p1 <- list_panes(s)[[1]]
  p2 <- split_window()

  kill_pane(p1)
  expect_identical(list_panes(s)[[1]], p2)

  kill_session(s)
})

test_that("other panes can be killed", {
  skip_if_tmux_not_installed()
  s <- new_session()
  p1 <- list_panes(s)[[1]]
  split_window()
  split_window()
  split_window()

  kill_pane(p1, inverse = TRUE)

  expect_length(list_panes(s), 1)
  expect_identical(list_panes(s)[[1]], p1)

  kill_session(s)
})


test_that("clock_mode works", {
  skip_if_tmux_not_installed()
  s <- new_session()
  expect_identical(s, clock_mode(s))
  kill_session(s)
})

test_that("contents can be captured", {
  skip_if_tmux_not_installed()
  specified_height <- 10
  s <- new_session(shell_command = "cat", height = specified_height)

  # Before version 2.6, the actual height is one less than the specified height
  # see https://github.com/tmux/tmux/blob/349617a818/CHANGES#L634-L636

  if (tmux_version() >= 2.6) {
    expected_height <- specified_height
  } else {
    expected_height <- specified_height - 1
  }

  Sys.sleep(0.5)
  expect_length(capture_pane(s), expected_height)
  expect_match(paste0(rep("\n", expected_height), collapse = ""),
               capture_pane(s, cat = TRUE), fixed = TRUE)

  expect_length(capture_pane(s, start = 0, end = 1), 2)
  kill_session(s)
})




test_that("stdout of pane can be connected", {
  skip_if_tmux_not_installed()
  out_file <- tempfile("tmuxr")
  s <- new_session(shell_command = "cat > /dev/null")
  Sys.sleep(0.5)
  pipe_pane(s, paste0("cat >> ", out_file), stdout = TRUE, open = TRUE)
  send_keys(s, "Hello there!", literal = TRUE)
  send_keys(s, "Enter")
  pipe_pane(s)
  kill_session(s)
  Sys.sleep(0.5)
  output <- paste0(readLines(out_file, warn = FALSE), collapse = "\n")
  unlink(out_file)
  expect_identical(output, "Hello there!")
})

test_that("stdin of pane can be connected", {
  skip_if_tmux_not_installed()
  s <- new_session(shell_command = "cat > /dev/null")
  Sys.sleep(0.5)
  if (tmux_version() < 2.8) {
    expect_error(pipe_pane(s, "seq 5", stdin = TRUE))
  } else {
    pipe_pane(s, "seq 5", stdin = TRUE)
    Sys.sleep(0.5)
    pipe_pane(s)
    Sys.sleep(0.5)
    expect_identical(head(capture_pane(s), 5),
                     as.character(seq(5)))
  }
  kill_session(s)
})

test_that("stdin and stdout cannot both be FALSE for pipe_pane", {
  skip_if_tmux_not_installed()
  s <- new_session(shell_command = "cat > /dev/null")
  Sys.sleep(0.5)
  expect_error(pipe_pane(s, "seq 5", stdin = FALSE, stdout = FALSE))
  kill_session(s)
})

test_that("panes are printed correctly", {
  skip_if_tmux_not_installed()
  kill_server()
  s <- new_session("foobarbaz", shell_command = "cat")
  Sys.sleep(0.5)
  p <- list_panes(s)[[1]]
  expect_output(print(p), "^tmuxr pane foobarbaz:0.0: ")
})
