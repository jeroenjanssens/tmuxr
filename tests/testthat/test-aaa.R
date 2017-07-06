context("prerequisites")

test_that("the server is not already running", {
  expect_error(info(), "no server running")
})


