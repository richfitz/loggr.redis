##' @title Activate logging to Redis
##' @param con A redis connection object, created by
##' \code{RedisAPI::hiredis}.
##' @param key Key to log to.  If this exists it \emph{must} be a
##' list (this is enforced in this function but must remain true while
##' logging is active).
##' @param ... list of quoted or unquoted events to log. In none are
##' provided all log events will be captured.
##' @param .warning logical: capture regular warnings (\code{simpleWarning})?
##' @param .error logical: capture regular errors (\code{simpleError})?
##' @param .message logical: capture regular messages (\code{simpleMessage})?
##' @param .formatter function: the formatting function used to convert
##' a log event to its character representation for the log file.
##' Note that the default formatter here is to JSON, not to text.
##' @param subscriptions character vector: optional list of
##' subscriptions to use (in place of specifying with \code{...}).
##' @export
##' @importFrom RedisAPI hiredis
log_redis <- function(con, key, ...,
                      .warning   = TRUE, .error = TRUE, .message = TRUE,
                      .formatter = format_log_entry_json,
                      subscriptions = NULL) {
  name <- sprintf("%s:%d:%s", con$host, con$port, key)
  if (con$EXISTS(key) == 1L && con$TYPE(key) != "list") {
    stop("If key exists it must be a list")
  }

  ## TODO: This sill simplify when loggr drops the ... argument.
  subscriptions <- loggr:::loggr_subscriptions(.warning, .error, .message, ...,
                                               subscriptions=subscriptions)
  obj <- list(name=name, con=con, key=key, write=write_redis)
  ## TODO: Need to export loggr_start from loggr
  loggr:::loggr_start(obj, subscriptions, .formatter)
}

## Thie handles the actual writing to Redis
write_redis <- function(obj, str) {
  obj$con$RPUSH(obj$key, str)
}

##' @title JSON log entry formatter.
##' @param event The log event to format
##' @export
##' @importFrom jsonlite toJSON
format_log_entry_json <- function(event) {
  ## NOTE: might be worth putting this into loggr itself?
  jsonlite::toJSON(unclass(event))
}
