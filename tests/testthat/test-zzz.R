context("server")

test_that("the server can be killed", {
  expect_error(kill_server(), NA)
  expect_error(kill_server())
})
