# loggr.redis

[![Build Status](https://travis-ci.org/richfitz/loggr.redis.png?branch=master)](https://travis-ci.org/richfitz/loggr.redis)

Redis support for [`loggr`](https://github.com/smbache/loggr)

```r
con <- RedisAPI::hiredis()
loggr.redis::log_redis(con, "mykey")
jsonlite::fromJSON(con$LINDEX("mykey", -1))
# $level
# [1] "INFO"
#
# $message
# [1] "Activating logging to 127.0.0.1:6379:mykey"
#
# $time
# [1] "2015-06-10 18:39:03"
```

## Installation

Requires two (currently non-CRAN packages)

- [`loggr`](https://github.com/smbache/loggr)
- [`RedisAPI`](https://github.com/ropensci/RedisAPI)

Install with

```r
devtools::install_github(c("smbache/loggr", "ropensci/RedisAPI"))
```
