context("send")

test_that("keys can be sent", {
  cp <- function(x) capture_pane(x, start = 0, end = 5)

  s <- new_session(shell_command = "cat")
  expect_identical(cp(s), c("",
                            "",
                            "",
                            "",
                            "",
                            ""))

  send_keys(s, "hello")
  expect_identical(cp(s), c("hello",
                            "",
                            "",
                            "",
                            "",
                            ""))

  send_keys(s, c("Space", "world?", "BSpace", "!"))
  expect_identical(cp(s), c("hello world!",
                            "",
                            "",
                            "",
                            "",
                            ""))

  send_keys(s, "Enter")
  expect_identical(cp(s), c("hello world!",
                            "hello world!",
                            "",
                            "",
                            "",
                            ""))

  send_keys(s, "Speak", "Friend", "and", "Enter")
  expect_identical(cp(s), c("hello world!",
                            "hello world!",
                            "SpeakFriendand",
                            "SpeakFriendand",
                            "",
                            ""))

  send_keys(s, "Speak", "Friend", "and", "Enter", literal = TRUE)
  expect_identical(cp(s), c("hello world!",
                            "hello world!",
                            "SpeakFriendand",
                            "SpeakFriendand",
                            "SpeakFriendandEnter",
                            ""))

  send_keys(s, "C-c") # exits cat and closes the session
  expect_error(cp(s))

})
