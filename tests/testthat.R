library(testthat)
library(sparklyr)
library(sparkxgb)

if (identical(Sys.getenv("NOT_CRAN"), "true")) {
  test_check("sparkxgb")
  on.exit({spark_disconnect_all()})
}