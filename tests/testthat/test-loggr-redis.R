context("loggr.redis")

test_that("basic use", {
  con <- RedisAPI::hiredis()
  key <- "loggr.redis"
  con$DEL(key)
  log_redis(con, key)
  expect_that(con$LLEN(key), equals(1))

  loggr::log_info("hello")
  expect_that(con$LLEN(key), equals(2))
  x <- jsonlite::fromJSON(con$LINDEX(key, -1))
  expect_that(x$level, equals("INFO"))
  expect_that(x$message, equals("hello"))

  loggr::log_info("hello", a=1, b=2)
  x <- jsonlite::fromJSON(con$LINDEX(key, -1))
  expect_that(x$a, equals(1))
  expect_that(x$b, equals(2))

  loggr::deactivate_log()
})
