.test_env <- new.env()
.test_env$sc <- NULL

testthat_spark_version <- function() {
  Sys.getenv("SPARK_VERSION", unset = "3.5")
}

testthat_spark_connection <- function() {
  version <- testthat_spark_version()
  spark_installed <- sparklyr::spark_installed_versions()
  if (nrow(spark_installed[spark_installed$spark == version, ]) == 0) {
    options(sparkinstall.verbose = TRUE)
    sparklyr::spark_install(version)
  }
  if (is.null(.test_env$sc)) {
    options(sparklyr.sanitize.column.names.verbose = TRUE)
    options(sparklyr.verbose = TRUE)
    options(sparklyr.na.omit.verbose = TRUE)
    options(sparklyr.na.action.verbose = TRUE)
    .test_env$sc <- sparklyr::spark_connect(master = "local", version = version)
  }
  .test_env$sc
}

testthat_tbl <- function(name) {
  sc <- testthat_spark_connection()
  tbl <- tryCatch(dplyr::tbl(sc, name), error = identity)
  if (inherits(tbl, "error")) {
    data <- eval(as.name(name), envir = parent.frame())
    invisible(
      tbl <- dplyr::copy_to(sc, data, name = name)
    )
  }
  tbl
}

skip_unless_verbose <- function(message = NULL) {
  message <- message %||% "Verbose test skipped"
  verbose <- Sys.getenv("SPARKLYR_TESTS_VERBOSE", unset = NA)
  if (is.na(verbose)) skip(message)
  invisible(TRUE)
}

test_requires <- function(...) {
  for (pkg in list(...)) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      fmt <- "test requires '%s' but '%s' is not installed"
      skip(sprintf(fmt, pkg, pkg))
    }
  }

  invisible(TRUE)
}

check_params <- function(test_args, params) {
  purrr::iwalk(
    test_args,
    function(.x, .y) {
      testthat::expect_equal(.x, params[[.y]], info = .y)
    }
  )
}

test_param_setting <- function(sc, fn, test_args) {
  collapse_sublists <- function(x) purrr::map_if(x, rlang::is_bare_list, unlist)

  params1 <- do.call(fn, c(list(x = sc), test_args)) %>%
    sparklyr::ml_params(allow_null = TRUE) %>%
    collapse_sublists()

  params2 <- do.call(fn, c(list(x = sparklyr::ml_pipeline(sc)), test_args)) %>%
    sparklyr::ml_stage(1) %>%
    sparklyr::ml_params(allow_null = TRUE) %>%
    collapse_sublists()

  test_args <- collapse_sublists(test_args)
  check_params(test_args, params1)
  check_params(test_args, params2)
}

test_default_args <- function(sc, fn) {
  default_args <- rlang::fn_fmls(fn) %>%
    as.list() %>%
    purrr::discard(~ is.symbol(.x) || is.language(.x)) %>%
    # rlang::modify(uid = NULL) %>%
    purrr::compact()

  params <- do.call(fn, list(x = sc)) %>%
    sparklyr::ml_params(allow_null = TRUE)

  check_params(default_args, params)
}
