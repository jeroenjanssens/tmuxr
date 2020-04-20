context("window")




test_that("windows are printed correctly", {
  kill_server()
  s <- new_session("foobarbaz", shell_command = "cat")
  w <- list_windows(s)[[1]]
  expect_output(print(w), "^tmuxr window foobarbaz:0: ")
})

kill_server()
