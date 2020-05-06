context("select")

test_that("selecting panes works", {
  skip_if_tmux_not_installed()
  skip_if(tmux_version() < 2.3)

  sc <- function(n) paste0("echo ", as.character(n), "; cat")

  sw <- function(target, n, ...) {
    p <- split_window(target, shell_command = sc(n), ...)
    Sys.sleep(0.1)
    p
  }

  s1 <- new_session("foo", shell_command = sc("a"), width = 90, height = 30)
  Sys.sleep(0.5)
  w1 <- list_windows(s1)[[1]]
  pa <- list_panes(w1)[[1]]

  expect_identical(select_pane(), pa)

  pb <- sw(pa, "b", vertical = FALSE, size = 0.66)
  pc <- sw(pb, "c", vertical = FALSE)
  pd <- sw(pc, "d", full = TRUE)
  pe <- sw(pd, "e", vertical = FALSE, size = 0.66)
  pf <- sw(pe, "f", vertical = FALSE)
  pg <- sw(pf, "g", full = TRUE)
  ph <- sw(pg, "h", vertical = FALSE, size = 0.66)
  pi <- sw(ph, "i", vertical = FALSE)

  expect_identical(select_pane(), pi)
  expect_identical(select_pane_top_left(), pa)
  expect_identical(select_pane_top(), pb)
  expect_identical(select_pane_top_right(), pc)
  expect_identical(select_pane_right(), pf)
  expect_identical(select_pane_bottom_right(), pi)
  expect_identical(select_pane_bottom(), ph)
  expect_identical(select_pane_bottom_left(), pg)
  expect_identical(select_pane_left(), pd)

  expect_identical(select_pane(pe), pe)
  expect_identical(select_pane(s1), pe)
  expect_identical(select_pane(w1), pe)

  select_pane(pe)
  expect_identical(select_pane_active(), pe)
  expect_identical(select_pane_up_of(), pb)
  expect_identical(select_pane_down_of(), pe)
  expect_identical(select_pane_left_of(), pd)
  expect_identical(select_pane_right_of(), pe)
  expect_identical(select_pane_right_of(), pf)
  expect_identical(select_pane_last(), pe)

  expect_identical(select_pane_previous(), pd)
  expect_identical(select_pane_next(), pe)

  expect_warning(select_pane(pe, "{last}"))
  kill_session(s1)
})


test_that("selecting windows works", {
  skip_if_tmux_not_installed()
  sc <- function(n) paste0("echo ", as.character(n), "; cat")
  nw <- function(n, ...) {
    w <- new_window(shell_command = sc(n), ...)
    name(w) <- n
    w
  }


  s0 <- new_session("s0", window_name = "w0", shell_command = sc("w0"))
  Sys.sleep(0.1)
  w0 <- list_windows(s0)[[1]]
  w1 <- nw("w1")

  s1 <- new_session("s1", window_name = "w2", shell_command = sc("w2"))
  Sys.sleep(0.1)
  w2 <- list_windows(s1)[[1]]
  w3 <- nw("w3")

  expect_identical(select_window(w0), w0)
  expect_identical(select_window(w1), w1)
  expect_identical(select_window(s0), w1)

  expect_identical(select_window(w2), w2)
  expect_identical(select_window(s1), w2)
  expect_identical(select_window(s0), w1)


  expect_identical(select_window_start(s0), w0)
  expect_identical(select_window_end(s1), w3)

  expect_identical(select_window_next(s0), w1)
  expect_identical(select_window_next(s0), w0)

  expect_identical(select_window_last(s0), w1)
  expect_identical(select_window_last(s0), w0)
  expect_identical(select_window_previous(s0), w1)
  expect_identical(select_window_previous(s1), w2)

  expect_warning(select_window(w0, "{last}"))
  expect_identical(select_window_active(s0), w0)
  expect_identical(select_window_active(), w2)
  kill_session(s0)
  kill_session(s1)
})
