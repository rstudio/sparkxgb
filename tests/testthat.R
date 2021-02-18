library(testthat)
library(sparklyr)
library(sparkxgb)

if (identical(Sys.getenv("NOT_CRAN"), "true")) {
  # timeout for downloading Apache Spark
  options(timeout = 300)

  test_check("sparkxgb")
  on.exit({spark_disconnect_all()})
}
